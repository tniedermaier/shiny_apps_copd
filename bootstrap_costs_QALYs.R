# app.R

library(shiny)
library(shinyjs)

#########################################
# Helper function: gamma_params
#   Given mean and sd, returns the shape
#   and rate parameters for a Gamma dist.
#########################################
gamma_params <- function(mean, sd){
  shape <- (mean^2)/(sd^2)
  rate  <- mean/(sd^2)
  list(shape=shape, rate=rate)
}

#########################################
# Helper function: mysummary
#   Returns a data frame with mean and sd
#########################################
mysummary <- function(x){
  data.frame(
    Mean = mean(x),
    SD   = sd(x)
  )
}

ui <- fluidPage(
  useShinyjs(),
  
  titlePanel("Bootstrapped Trial Effects and Costs (Uncorrelated)"),
  
  sidebarLayout(
    sidebarPanel(
      # Number of repeated simulations
      sliderInput("num_sims", "Number of Simulations:", 
                  min = 1, max = 1000, value = 200),
      
      # Sample size for each simulation
      numericInput("sampleSize", "Sample Size per Simulation:", 
                   min = 1, value = 200),
      
      # Inputs for strategy 1 (effects)
      numericInput("mean_effects1", "Mean effects (strategy 1):", 
                   value = 0.5, min = 0, step = 0.01),
      numericInput("sd_effects1",   "SD effects (strategy 1):",   
                   value = 0.5, min = 0, step = 0.01),
      
      # Inputs for strategy 2 (effects)
      numericInput("mean_effects2", "Mean effects (strategy 2):", 
                   value = 0.5, min = 0, step = 0.01),
      numericInput("sd_effects2",   "SD effects (strategy 2):",   
                   value = 0.5, min = 0, step = 0.01),
      
      # Inputs for strategy 1 (costs)
      numericInput("mean_costs1", "Mean costs (strategy 1):",
                   value = 500, min = 0, step = 10),
      numericInput("sd_costs1",   "SD costs (strategy 1):",
                   value = 500, min = 0, step = 10),
      
      # Inputs for strategy 2 (costs)
      numericInput("mean_costs2", "Mean costs (strategy 2):",
                   value = 500, min = 0, step = 10),
      numericInput("sd_costs2",   "SD costs (strategy 2):",
                   value = 500, min = 0, step = 10),
      
      # How many simulation results to show in the table
      sliderInput("num_obs", 
                  "Number of simulation results to display:", 
                  min = 1, max = 50, value = 20),
      
      # Button to trigger re-simulation
      actionButton("simulate", "Simulate / Update")
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  
                  #########################################
                  # First tab: Effects
                  #########################################
                  tabPanel("Effects",
                           h4("Distribution of Effects: Strategy 1 & Strategy 2"),
                           
                           splitLayout(
                             plotOutput("dist_plot_effects1", height="400px"),  # left
                             plotOutput("dist_plot_effects2", height="400px")   # right
                           ),
                           
                           h5("Mean & SD of Sample Means (Strategy 1):"),
                           verbatimTextOutput("dist_effects_num1"),
                           h5("Mean & SD of Sample Means (Strategy 2):"),
                           verbatimTextOutput("dist_effects_num2")
                  ),
                  
                  #########################################
                  # Second tab: Costs
                  #########################################
                  tabPanel("Costs",
                           h4("Distribution of Costs: Strategy 1 & Strategy 2"),
                           splitLayout(
                             plotOutput("dist_plot_costs1", height="400px"),  # left
                             plotOutput("dist_plot_costs2", height="400px")   # right
                           ),
                           
                           h5("Mean & SD of Sample Means (Strategy 1):"),
                           verbatimTextOutput("dist_costs_num1"),
                           h5("Mean & SD of Sample Means (Strategy 2):"),
                           verbatimTextOutput("dist_costs_num2")
                  ),
                  
                  #########################################
                  # Third tab: ICER + CEAC
                  #########################################
                  tabPanel("ICER + CEAC",
                           h4("Cost-Effectiveness Plane & CEAC"),
                           
                           splitLayout(
                             plotOutput("plot_ICER", height="400px"),
                             plotOutput("plot_CEAC", height="400px")
                           ),
                           
                           h5("Per-simulation differences in costs, QALYs, and ICER:"),
                           actionButton("button", "Show/hide first N simulation results"),
                           hidden(
                             div(id='text_div',
                                 verbatimTextOutput("diff_costs_diff_qalys")
                             )
                           )
                  )
      ),
      
      h5(uiOutput("tab1")),
      h5(uiOutput("tab2")),
      h5("By: Tobias Niedermaier Last edited: 2025-04-22.")
    )
  )
)

server <- function(input, output, session) {
  
  # Optional example links
  url1 <- a("here", href="https://ceacsim.shinyapps.io/bootstrap_normal_dist_pos_corr/")
  url2 <- a("here", href="https://ceacsim.shinyapps.io/bootstrap_normal_dist_neg_corr/")
  
  output$tab1 <- renderUI({
    tagList("Version assuming uncorrelated effects/costs. For the version assuming a positive correlation, see", url1)
  })
  output$tab2 <- renderUI({
    tagList("For the version assuming a negative correlation, see", url2)
  })
  
  ######################################################
  # REACTIVE DATA FOR EFFECTS
  # 1) "Original distribution" draws
  # 2) Repeated sample means for each simulation
  ######################################################
  
  # Original distribution for Strategy 1 (Normal)
  orig_effects1 <- reactive({
    req(input$simulate)
    rnorm(50000, mean = input$mean_effects1, sd = input$sd_effects1)
  })
  
  # Original distribution for Strategy 2 (Normal)
  orig_effects2 <- reactive({
    req(input$simulate)
    rnorm(50000, mean = input$mean_effects2, sd = input$sd_effects2)
  })
  
  # Sample means for Strategy 1
  sample_effects1 <- reactive({
    req(input$simulate)
    replicate(input$num_sims, {
      mean(rnorm(input$sampleSize,
                 mean = input$mean_effects1,
                 sd   = input$sd_effects1))
    })
  })
  
  # Sample means for Strategy 2
  sample_effects2 <- reactive({
    req(input$simulate)
    replicate(input$num_sims, {
      mean(rnorm(input$sampleSize,
                 mean = input$mean_effects2,
                 sd   = input$sd_effects2))
    })
  })
  
  ######################################################
  # PLOTS FOR EFFECTS: single y-axis with scaled sample
  ######################################################
  
  output$dist_plot_effects1 <- renderPlot({
    # Retrieve data
    orig_data <- orig_effects1()
    samp_data <- sample_effects1()
    
    # Build histogram objects (freq=TRUE, but we do not plot yet)
    h_orig <- hist(orig_data, breaks="FD", plot=FALSE)
    h_samp <- hist(samp_data, breaks="FD", plot=FALSE)
    
    # Scale factor so that the sample-means histogram 
    # visually lines up with the original distribution's max count.
    # We only apply this to h_samp$counts, so the original distribution
    # is shown with its actual frequencies.
    max_orig <- max(h_orig$counts)
    max_samp <- max(h_samp$counts)
    scale_factor <- ifelse(max_samp == 0, 1, max_orig / max_samp)
    
    # x-range: union of both data sets
    xrng <- range(c(orig_data, samp_data))
    # y-range: 0 up to the original distribution's max count
    yrng <- c(0, max_orig)
    
    # Plot the original distribution histogram with real frequencies
    plot(h_orig,
         col    = rgb(0.7, 0, 0, 0.4),
         border = NA,
         freq   = TRUE,
         xlim   = xrng,
         ylim   = yrng,
         main   = "Strategy 1: Effects",
         xlab   = "Effects")
    
    # Now scale up the sample-means histogram
    h_samp_scaled <- h_samp
    h_samp_scaled$counts <- h_samp$counts * scale_factor
    
    # Overlay the scaled histogram for sample means
    plot(h_samp_scaled,
         col    = rgb(0, 0, 1, 0.7),
         border = "white",
         freq   = TRUE,
         add    = TRUE)
    
    # Legend clarifies that sample means are scaled
    legend("topright",
           legend = c("Original Dist. (actual freq.)", 
                      "Sample Means (scaled)"),
           fill   = c(rgb(0.7,0,0,0.4), rgb(0,0,1,0.7)),
           bty    = "n")
  }, res = 96)
  
  output$dist_plot_effects2 <- renderPlot({
    orig_data <- orig_effects2()
    samp_data <- sample_effects2()
    
    h_orig <- hist(orig_data, breaks="FD", plot=FALSE)
    h_samp <- hist(samp_data, breaks="FD", plot=FALSE)
    
    max_orig <- max(h_orig$counts)
    max_samp <- max(h_samp$counts)
    scale_factor <- ifelse(max_samp == 0, 1, max_orig / max_samp)
    
    xrng <- range(c(orig_data, samp_data))
    yrng <- c(0, max_orig)
    
    # Original distribution with real frequencies
    plot(h_orig,
         col    = rgb(0.7, 0, 0, 0.4),
         border = NA,
         freq   = TRUE,
         xlim   = xrng,
         ylim   = yrng,
         main   = "Strategy 2: Effects",
         xlab   = "Effects")
    
    # Scale sample means
    h_samp_scaled <- h_samp
    h_samp_scaled$counts <- h_samp$counts * scale_factor
    
    # Overlay
    plot(h_samp_scaled,
         col    = rgb(0, 0, 1, 0.7),
         border = "white",
         freq   = TRUE,
         add    = TRUE)
    
    legend("topright",
           legend = c("Original Dist. (actual freq.)", 
                      "Sample Means (scaled)"),
           fill   = c(rgb(0.7,0,0,0.4), rgb(0,0,1,0.7)),
           bty    = "n")
  }, res = 96)
  
  # Numeric summaries for sample means
  output$dist_effects_num1 <- renderPrint({
    mysummary(sample_effects1())
  })
  output$dist_effects_num2 <- renderPrint({
    mysummary(sample_effects2())
  })
  
  ######################################################
  # REACTIVE DATA FOR COSTS (Gamma)
  #  - original distribution + sample means
  ######################################################
  
  orig_costs1 <- reactive({
    req(input$simulate)
    params1 <- gamma_params(input$mean_costs1, input$sd_costs1)
    rgamma(50000, shape = params1$shape, rate = params1$rate)
  })
  
  orig_costs2 <- reactive({
    req(input$simulate)
    params2 <- gamma_params(input$mean_costs2, input$sd_costs2)
    rgamma(50000, shape = params2$shape, rate = params2$rate)
  })
  
  sample_costs1 <- reactive({
    req(input$simulate)
    params1 <- gamma_params(input$mean_costs1, input$sd_costs1)
    replicate(input$num_sims, {
      mean(rgamma(input$sampleSize, 
                  shape=params1$shape, 
                  rate =params1$rate))
    })
  })
  
  sample_costs2 <- reactive({
    req(input$simulate)
    params2 <- gamma_params(input$mean_costs2, input$sd_costs2)
    replicate(input$num_sims, {
      mean(rgamma(input$sampleSize, 
                  shape=params2$shape, 
                  rate =params2$rate))
    })
  })
  
  ######################################################
  # PLOTS FOR COSTS: single y-axis w/ scaled sample
  ######################################################
  
  output$dist_plot_costs1 <- renderPlot({
    orig_data <- orig_costs1()
    samp_data <- sample_costs1()
    
    h_orig <- hist(orig_data, breaks="FD", plot=FALSE)
    h_samp <- hist(samp_data, breaks="FD", plot=FALSE)
    
    max_orig <- max(h_orig$counts)
    max_samp <- max(h_samp$counts)
    scale_factor <- ifelse(max_samp == 0, 1, max_orig / max_samp)
    
    xrng <- range(c(orig_data, samp_data))
    yrng <- c(0, max_orig)
    
    # Original distribution with real frequencies
    plot(h_orig,
         col    = rgb(0.7, 0, 0, 0.4),
         border = NA,
         freq   = TRUE,
         xlim   = xrng,
         ylim   = yrng,
         main   = "Strategy 1: Costs",
         xlab   = "Costs")
    
    # Scale sample means
    h_samp_scaled <- h_samp
    h_samp_scaled$counts <- h_samp$counts * scale_factor
    
    plot(h_samp_scaled,
         col    = rgb(0, 0, 1, 0.7),
         border = "white",
         freq   = TRUE,
         add    = TRUE)
    
    legend("topright",
           legend = c("Original Dist. (actual freq.)", 
                      "Sample Means (scaled)"),
           fill   = c(rgb(0.7,0,0,0.4), rgb(0,0,1,0.7)),
           bty    = "n")
  }, res = 96)
  
  output$dist_plot_costs2 <- renderPlot({
    orig_data <- orig_costs2()
    samp_data <- sample_costs2()
    
    h_orig <- hist(orig_data, breaks="FD", plot=FALSE)
    h_samp <- hist(samp_data, breaks="FD", plot=FALSE)
    
    max_orig <- max(h_orig$counts)
    max_samp <- max(h_samp$counts)
    scale_factor <- ifelse(max_samp == 0, 1, max_orig / max_samp)
    
    xrng <- range(c(orig_data, samp_data))
    yrng <- c(0, max_orig)
    
    # Original distribution with real frequencies
    plot(h_orig,
         col    = rgb(0.7, 0, 0, 0.4),
         border = NA,
         freq   = TRUE,
         xlim   = xrng,
         ylim   = yrng,
         main   = "Strategy 2: Costs",
         xlab   = "Costs")
    
    # Scale sample means
    h_samp_scaled <- h_samp
    h_samp_scaled$counts <- h_samp$counts * scale_factor
    
    plot(h_samp_scaled,
         col    = rgb(0, 0, 1, 0.7),
         border = "white",
         freq   = TRUE,
         add    = TRUE)
    
    legend("topright",
           legend = c("Original Dist. (actual freq.)", 
                      "Sample Means (scaled)"),
           fill   = c(rgb(0.7,0,0,0.4), rgb(0,0,1,0.7)),
           bty    = "n")
  }, res = 96)
  
  # Numeric summaries for the sample means
  output$dist_costs_num1 <- renderPrint({
    mysummary(sample_costs1())
  })
  output$dist_costs_num2 <- renderPrint({
    mysummary(sample_costs2())
  })
  
  ######################################################
  # COST-EFFECTIVENESS PLANE & CEAC
  ######################################################
  
  output$plot_ICER <- renderPlot({
    dc <- sample_costs2() - sample_costs1()
    de <- sample_effects2() - sample_effects1()
    
    xlim_min <- min(de, 0)
    xlim_max <- max(de, 0)
    ylim_min <- min(dc, 0)
    ylim_max <- max(dc, 0)
    
    plot(NA, NA, 
         xlim = c(xlim_min, xlim_max),
         ylim = c(ylim_min, ylim_max),
         xlab = "Difference in QALYs (2 - 1)",
         ylab = "Difference in Costs (2 - 1)",
         main = "Cost-Effectiveness Plane")
    abline(v=0, h=0, lty=2)
    
    points(de, dc, pch=16, cex=0.7, col="blue")
    
    # Red dot at the "point estimate" from user input
    # = (mean_costs2 - mean_costs1, mean_effects2 - mean_effects1)
    point_diff_costs  <- input$mean_costs2  - input$mean_costs1
    point_diff_effect <- input$mean_effects2 - input$mean_effects1
    
    points(point_diff_effect, point_diff_costs,
           pch=19, col="red", cex=1.5)
    
  }, res = 96)
  
  output$plot_CEAC <- renderPlot({
    dc <- sample_costs2() - sample_costs1()
    de <- sample_effects2() - sample_effects1()
    ratio <- dc / de
    ratio_finite <- ratio[is.finite(ratio)]
    
    if(length(ratio_finite) < 2) {
      plot(0,0,type="n", xlab="WTP",ylab="Prob(Strategy 2 cost-effective)",
           main="CEAC", xlim=c(0,1), ylim=c(0,1))
      text(0.5,0.5,"Insufficient valid ratios", cex=1.2)
      return()
    }
    
    # 99.9th percentile for ratio
    wtp_999 <- quantile(ratio_finite, probs=0.999, na.rm=TRUE)
    if(wtp_999 < 0) {
      # If the ratio is negative at 99.9%,
      # meaning Strategy 2 is cheaper in almost all sims
      wtp_seq <- seq(0, 1000, length.out=200)
    } else {
      wtp_seq <- seq(0, wtp_999, length.out=200)
    }
    
    ceac_vals <- sapply(wtp_seq, function(w) {
      mean(ratio < w, na.rm=TRUE)
    })
    
    plot(wtp_seq, ceac_vals, type="l", lwd=2, col="blue",
         ylim=c(0,1),
         xlab="Willingness-to-pay (WTP)",
         ylab="Probability(Strategy 2 cost-effective)",
         main="CEAC")
    abline(h=0.5, col="gray", lty=3)
  }, res = 96)
  
  ######################################################
  # Toggle table with the first N simulation results
  ######################################################
  observeEvent(input$button, {
    toggle("text_div")
    output$diff_costs_diff_qalys <- renderPrint({
      c1 <- sample_costs1()
      c2 <- sample_costs2()
      e1 <- sample_effects1()
      e2 <- sample_effects2()
      
      dc <- c2 - c1
      de <- e2 - e1
      icer <- dc / de
      
      res <- data.frame(
        diff_costs = round(dc, 2),
        diff_QALYs = round(de, 4),
        ICER       = round(icer, 2)
      )
      n_display <- min(nrow(res), input$num_obs)
      res[1:n_display, ]
    })
  })
}

shinyApp(ui, server)
