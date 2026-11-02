
library(shiny)
library(shinyjs)

ui <- fluidPage(
  titlePanel("COPD Markov Modell – Shiny App"),
  useShinyjs(),  # Einbinden von shinyjs für Reset-Funktionalität
  sidebarLayout(
    sidebarPanel(
      # Verpackeln aller Inputs in einen Container mit id "inputForm"
      div(
        id = "inputForm",
        tabsetPanel(
          tabPanel("Progressionsraten",
                   sliderInput("prog1", "Progressionsrate Stage 1 (prog1):",
                               min = 0.01403/2, max = 0.01403*2, value = 0.01403, step = 0.0001),
                   sliderInput("prog2", "Progressionsrate Stage 2 (prog2):",
                               min = 0.01031/2, max = 0.01031*2, value = 0.01031, step = 0.0001),
                   sliderInput("prog3", "Progressionsrate Stage 3 (prog3):",
                               min = 0.02298/2, max = 0.02298*2, value = 0.02298, step = 0.0001),
                   sliderInput("prog1_int", "Progressionsrate Stage 1, Intervention (prog1_int):",
                               min = 0.00247/2, max = 0.00247*2, value = 0.00247, step = 0.0001),
                   sliderInput("prog2_int", "Progressionsrate Stage 2, Intervention (prog2_int):",
                               min = 0.003/2, max = 0.003*2, value = 0.003, step = 0.0001),
                   sliderInput("prog3_int", "Progressionsrate Stage 3, Intervention (prog3_int):",
                               min = 0.00686/2, max = 0.00686*2, value = 0.00686, step = 0.0001)
          ),
          tabPanel("Exazerbationen",
                   sliderInput("p_mod2", "Wahrscheinlichkeit mod. Exazerbation Stage 2 (p_mod2):",
                               min = 0.18376/2, max = 0.18376*2, value = 0.18376, step = 0.001),
                   sliderInput("d_mod2", "Nutzenänderung mod. AE Stage 2 (d_mod2):",
                               min = -0.01975*2, max = -0.01975/2, value = -0.01975, step = 0.0001),
                   sliderInput("p_sev2", "Wahrscheinlichkeit sev. Exazerbation Stage 2 (p_sev2):",
                               min = 0.03854/2, max = 0.03854*2, value = 0.03854, step = 0.001),
                   sliderInput("d_sev2", "Nutzenänderung sev. AE Stage 2 (d_sev2):",
                               min = -0.03075*2, max = -0.03075/2, value = -0.03075, step = 0.0001),
                   
                   sliderInput("p_mod3", "Wahrscheinlichkeit mod. Exazerbation Stage 3 (p_mod3):",
                               min = 0.26767/2, max = 0.26767*2, value = 0.26767, step = 0.001),
                   sliderInput("d_mod3", "Nutzenänderung mod. AE Stage 3 (d_mod3):",
                               min = -0.01875*2, max = -0.01875/2, value = -0.01875, step = 0.0001),
                   sliderInput("p_sev3", "Wahrscheinlichkeit sev. Exazerbation Stage 3 (p_sev3):",
                               min = 0.03774/2, max = 0.03774*2, value = 0.03774, step = 0.001),
                   sliderInput("d_sev3", "Nutzenänderung sev. AE Stage 3 (d_sev3):",
                               min = -0.02919*2, max = -0.02919/2, value = -0.02919, step = 0.0001),
                   
                   sliderInput("p_mod4", "Wahrscheinlichkeit mod. Exazerbation Stage 4 (p_mod4):",
                               min = 0.28057/2, max = 0.28057*2, value = 0.28057, step = 0.001),
                   sliderInput("d_mod4", "Nutzenänderung mod. AE Stage 4 (d_mod4):",
                               min = -0.01625*2, max = -0.01625/2, value = -0.01625, step = 0.0001),
                   sliderInput("p_sev4", "Wahrscheinlichkeit sev. Exazerbation Stage 4 (p_sev4):",
                               min = 0.04855/2, max = 0.04855*2, value = 0.04855, step = 0.001),
                   sliderInput("d_sev4", "Nutzenänderung sev. AE Stage 4 (d_sev4):",
                               min = -0.03502*2, max = -0.03502/2, value = -0.03502, step = 0.0001)
          ),
          tabPanel("Nutzwerte",
                   sliderInput("u_1", "Nutzen Stage 1 (u_1):",
                               min = 0, max = 1, value = 0.84, step = 0.01),
                   sliderInput("u_2", "Nutzen Stage 2 (u_2):",
                               min = 0, max = 1, value = 0.79, step = 0.01),
                   sliderInput("u_3", "Nutzen Stage 3 (u_3):",
                               min = 0, max = 1, value = 0.75, step = 0.01),
                   sliderInput("u_4", "Nutzen Stage 4 (u_4):",
                               min = 0, max = 1, value = 0.65, step = 0.01)
          ),
          tabPanel("Kosten",
                   sliderInput("c_1", "Kosten Stage 1 (c_1):",
                               min = 102.64/2, max = 102.64*2, value = 102.64, step = 0.1),
                   sliderInput("c_2", "Kosten Stage 2 (c_2):",
                               min = 184.69/2, max = 184.69*2, value = 184.69, step = 0.1),
                   sliderInput("c_mod2", "Kosten mod. AE Stage 2 (c_mod2):",
                               min = 39.86/2, max = 39.86*2, value = 39.86, step = 0.1),
                   sliderInput("c_sev2", "Kosten sev. AE Stage 2 (c_sev2):",
                               min = 2923.94/2, max = 2923.94*2, value = 2923.94, step = 1),
                   sliderInput("c_3", "Kosten Stage 3 (c_3):",
                               min = 366.57/2, max = 366.57*2, value = 366.57, step = 0.1),
                   sliderInput("c_mod3", "Kosten mod. AE Stage 3 (c_mod3):",
                               min = 52.90/2, max = 52.90*2, value = 52.90, step = 0.1),
                   sliderInput("c_sev3", "Kosten sev. AE Stage 3 (c_sev3):",
                               min = 3109.05/2, max = 3109.05*2, value = 3109.05, step = 1),
                   sliderInput("c_4", "Kosten Stage 4 (c_4):",
                               min = 431.35/2, max = 431.35*2, value = 431.35, step = 0.1),
                   sliderInput("c_mod4", "Kosten mod. AE Stage 4 (c_mod4):",
                               min = 51.52/2, max = 51.52*2, value = 51.52, step = 0.1),
                   sliderInput("c_sev4", "Kosten sev. AE Stage 4 (c_sev4):",
                               min = 3322.59/2, max = 3322.59*2, value = 3322.59, step = 1),
                   sliderInput("c_int", "Interventionskosten (c_int):",
                               min = 595.92/2, max = 595.92*2, value = 595.92, step = 0.1),
                   h4("Kosten Usual Care (c_uc) ist fix auf 0")
          ),
          tabPanel("Sonstige",
                   h4("Zykluslänge: 3 Monate (fix)"),
                   sliderInput("disc_e", "Diskontsatz (disc_e):",
                               min = 0.03/2, max = 0.03*2, value = 0.03, step = 0.001),
                   sliderInput("eff_int", "Effektivität Intervention (eff_int):",
                               min = 0.22/2, max = 0.22*2, value = 0.22, step = 0.01),
                   sliderInput("eff_uc", "Effektivität Usual Care (eff_uc):",
                               min = 0.06/2, max = 0.06*2, value = 0.06, step = 0.01)
          )
        )
      ),
      # Reset-Knopf – im Server können Sie dann per shinyjs::reset("inputForm") alle Inputs zurücksetzen
      actionButton("reset", "Reset")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput("summaryText")),
        tabPanel("ICER over time", plotOutput("icerPlot")),
        tabPanel("Stage Distribution", plotOutput("stageDistribution"))
      )
    )
  )
)


server <- function(input, output) {
  
  observeEvent(input$reset, {
    reset("inputForm")
  })
  
  # Reaktive Funktion: Modell wird bei jeder Änderung der Eingabeparameter sofort neu berechnet.
  simResults <- reactive({
    # Parameter aus Inputs
    prog1      <- input$prog1
    prog2      <- input$prog2
    prog3      <- input$prog3
    prog1_int  <- input$prog1_int
    prog2_int  <- input$prog2_int
    prog3_int  <- input$prog3_int
    
    p_mod2     <- input$p_mod2
    d_mod2     <- input$d_mod2
    p_sev2     <- input$p_sev2
    d_sev2     <- input$d_sev2
    
    p_mod3     <- input$p_mod3
    d_mod3     <- input$d_mod3
    p_sev3     <- input$p_sev3
    d_sev3     <- input$d_sev3
    
    p_mod4     <- input$p_mod4
    d_mod4     <- input$d_mod4
    p_sev4     <- input$p_sev4
    d_sev4     <- input$d_sev4
    
    u_1        <- input$u_1
    u_2        <- input$u_2
    u_3        <- input$u_3
    u_4        <- input$u_4
    
    c_1        <- input$c_1
    c_2        <- input$c_2
    c_mod2     <- input$c_mod2
    c_sev2     <- input$c_sev2
    c_3        <- input$c_3
    c_mod3     <- input$c_mod3
    c_sev3     <- input$c_sev3
    c_4        <- input$c_4
    c_mod4     <- input$c_mod4
    c_sev4     <- input$c_sev4
    
    c_int      <- input$c_int
    c_uc       <- 0  # Fixwert für Usual Care
    
    cycle_length <- 3  # fest fixiert
    disc_e       <- input$disc_e
    eff_int      <- input$eff_int
    eff_uc       <- input$eff_uc
    
    N <- 241  # Anzahl der Zyklen
    
    ### Simulation für Raucher (dat_smo)
    dat_smo <- data.frame(matrix(nrow = N, ncol = 5))
    colnames(dat_smo) <- c("stage_1", "stage_2", "stage_3", "stage_4", "death")
    dat_smo[] <- 0
    dat_smo[1, "stage_1"] <- 100000
    
    dat_smo[, c("mort1", "mort2", "mort3")] <- NA
    dat_smo[1:20, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00122, 0.0021, 0.00497), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[21:40, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0021, 0.0036, 0.00852), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[41:60, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00302, 0.00518, 0.01225), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[61:80, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0047, 0.00804, 0.01899), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[81:100, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00805, 0.01377, 0.03238), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[101:120, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.01358, 0.02318, 0.05417), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[121:140, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0197, 0.03354, 0.07783), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[141:160, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.034, 0.05758, 0.13138), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[161:180, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.04729, 0.07969, 0.179), each = 20), ncol = 3, byrow = FALSE)
    dat_smo[181:241, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0884, 0.14672, 0.31397), each = 61), ncol = 3, byrow = FALSE)
    
    dat_smo$stage_1[-1] <- (100000 * cumprod(1 - prog1 - dat_smo$mort1))[1:(N - 1)]
    
    dat_smo$stage_2 <- NA
    dat_smo$stage_2[2] <- dat_smo[1, "stage_1"] * prog1
    dat_smo$stage_2[3] <- dat_smo$stage_2[2] * (1 - prog2 - dat_smo$mort2[1] - p_sev2 * 0.13819) + dat_smo[2, "stage_1"] * prog1
    ae_mort2 <- rep(NA, N)
    ae_mort2[3:20] <- 0.13819
    ae_mort2[21:40] <- 0.1369
    ae_mort2[41:60] <- 0.13552
    ae_mort2[61:80] <- 0.254
    ae_mort2[81:100] <- 0.24967
    ae_mort2[101:120] <- 0.24244
    ae_mort2[121:140] <- 0.30675
    ae_mort2[141:160] <- 0.28906
    ae_mort2[161:180] <- 0.27198
    ae_mort2[181:241] <- 0.21479
    
    assign_stage_2_smo <- function(data, i) {
      data$stage_2[i + 1] <- data$stage_2[i] * (1 - prog2 - data$mort2[i] - p_sev2 * ae_mort2[i]) + data$stage_1[i] * prog1
      data
    }
    for(i in 3:(N - 1)) { dat_smo <- assign_stage_2_smo(dat_smo, i) }
    
    dat_smo$stage_3 <- NA
    dat_smo$stage_3[2] <- 0
    dat_smo$stage_3[3] <- dat_smo[2, "stage_2"] * prog2
    ae_mort3 <- rep(NA, N)
    ae_mort3[3:20] <- 0.1357
    ae_mort3[21:40] <- 0.13261
    ae_mort3[41:60] <- 0.12933
    ae_mort3[61:80] <- 0.24568
    ae_mort3[81:100] <- 0.23523
    ae_mort3[101:120] <- 0.21762
    ae_mort3[121:140] <- 0.27345
    ae_mort3[141:160] <- 0.22866
    ae_mort3[161:180] <- 0.18392
    ae_mort3[181:241] <- 0.02336
    
    assign_stage_3_smo <- function(data, i) {
      data$stage_3[i + 1] <- data$stage_3[i] * (1 - prog3 - data$mort3[i] - p_sev3 * ae_mort3[i]) + data$stage_2[i] * prog2
      data
    }
    for(i in 3:(N - 1)) { dat_smo <- assign_stage_3_smo(dat_smo, i) }
    
    dat_smo$stage_4 <- NA
    dat_smo$stage_4[2:3] <- 0
    dat_smo$stage_4[4] <- dat_smo[4, "stage_3"] * prog3
    assign_stage_4_smo <- function(data, i) {
      data$stage_4[i + 1] <- data$stage_4[i] * (1 - data$mort3[i] - p_sev4 * ae_mort3[i]) + data$stage_3[i] * prog3
      data
    }
    for(i in 3:(N - 1)) { dat_smo <- assign_stage_4_smo(dat_smo, i) }
    
    dat_smo$death <- 100000 - rowSums(dat_smo[, c("stage_1", "stage_2", "stage_3", "stage_4")], na.rm = TRUE)
    
    dat_smo$LYG <- rowSums(dat_smo[, c("stage_1", "stage_2", "stage_3", "stage_4")], na.rm = TRUE) * cycle_length / 12
    dat_smo$LYG[c(1, N)] <- 0
    Cycle <- 0:(N - 1)
    discount_factor <- 1 / (((1 + disc_e)^(cycle_length / 12))^Cycle)
    dat_smo$LYG_discounted <- dat_smo$LYG * discount_factor
    
    qaly <- function(data, i) {
      (data[i, "stage_1"] * u_1 +
         data[i, "stage_2"] * (u_2 + p_mod2*d_mod2 + p_sev2*d_sev2) +
         data[i, "stage_3"] * (u_3 + p_mod3*d_mod3 + p_sev3*d_sev3) +
         data[i, "stage_4"] * (u_4 + p_mod4*d_mod4 + p_sev4*d_sev4)) * cycle_length / 12
    }
    dat_smo$QALY <- sapply(1:N, function(i) qaly(dat_smo, i))
    dat_smo$QALY[1] <- 0
    dat_smo$QALY_discounted <- dat_smo$QALY * discount_factor
    
    #c_sev4_ <- c_sev4 * 4.2365
    costs_smo_new2 <- Vectorize(function(data, i) {
      data[i, "stage_1"]*c_1 +
        data[i, "stage_2"]*(c_2 + p_mod2*c_mod2 + p_sev2*c_sev2) +
        data[i, "stage_3"]*(c_3 + p_mod3*c_mod3 + p_sev3*c_sev3) +
        data[i, "stage_4"]*(c_4 + p_mod4*c_mod4 + p_sev4*c_sev4)
    }, vectorize.args = "i")
    costs_new2 <- costs_smo_new2(dat_smo, 1:N)
    costs_new2[1] <- 0
    dat_smo$costs <- costs_new2
    dat_smo$costs_discounted <- dat_smo$costs * discount_factor
    
    ## Indirekte Kosten (Raucher)
    costs_stage2_stable <- c(0, rep(112.50, 19), rep(376.37, 20), rep(667.24, 20), rep(237.22, 20), rep(0, N-80))
    costs_stage3_stable <- c(0, rep(268.06, 19), rep(896.81, 20), rep(1589.9, 20), rep(565.24, 20), rep(0, N-80))
    costs_stage4_stable <- c(0, rep(281.24, 19), rep(940.92, 20), rep(1668.1, 20), rep(593.04, 20), rep(0, N-80))
    costs_stage2_mod_AE <- c(rep(491.94, 20), rep(446.16, 20), rep(364.35, 20), rep(115.30, 20), rep(0, N-80))
    costs_stage3_mod_AE <- c(rep(550.51, 20), rep(499.27, 20), rep(407.73, 20), rep(129.03, 20), rep(0, N-80))
    costs_stage4_mod_AE <- c(rep(491.94, 20), rep(446.16, 20), rep(364.35, 20), rep(115.30, 20), rep(0, N-80))
    costs_stage2_severe_AE <- c(rep(367, 20), rep(332.85, 20), rep(271.82, 20), rep(86.02, 20), rep(0, N-80))
    costs_stage3_severe_AE <- c(rep(663.73, 20), rep(601.96, 20), rep(491.58, 20), rep(155.56, 20), rep(0, N-80))
    costs_stage4_severe_AE <- c(rep(648.12, 20), rep(587.79, 20), rep(480.02, 20), rep(151.9, 20), rep(0, N-80))
    
    dat_smo$stage_1_ind_costs <- 0
    dat_smo$stage_2_ind_costs <- dat_smo$stage_2*(costs_stage2_stable + p_mod2*costs_stage2_mod_AE + p_sev2*costs_stage2_severe_AE)
    dat_smo$stage_3_ind_costs <- dat_smo$stage_3*(costs_stage3_stable + p_mod3*costs_stage3_mod_AE + p_sev3*costs_stage3_severe_AE)
    dat_smo$stage_4_ind_costs <- dat_smo$stage_4*(costs_stage4_stable + p_mod4*costs_stage4_mod_AE + p_sev4*costs_stage4_severe_AE)
    dat_smo$ind_costs <- rowSums(dat_smo[, c("stage_1_ind_costs","stage_2_ind_costs","stage_3_ind_costs","stage_4_ind_costs")], na.rm = TRUE)
    dat_smo$ind_costs_discounted <- dat_smo$ind_costs * discount_factor
    
    dat_smo$effects <- dat_smo$QALY_discounted / 100000
    
    ### Simulation für Ex-Raucher (dat_fosmo)
    dat_fosmo <- data.frame(matrix(nrow = N, ncol = 5))
    colnames(dat_fosmo) <- c("stage_1", "stage_2", "stage_3", "stage_4", "death")
    dat_fosmo[] <- 0
    dat_fosmo[1, "stage_1"] <- 100000
    dat_fosmo[, c("mort1", "mort2", "mort3")] <- NA
    dat_fosmo[1:20, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0008, 0.00136, 0.00323), each = 20),
                                                            ncol = 3, byrow = FALSE)
    dat_fosmo[21:40, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00137, 0.00234, 0.00555), each = 20),
                                                             ncol = 3, byrow = FALSE)
    dat_fosmo[41:60, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00251, 0.0043, 0.01018), each = 20),
                                                             ncol = 3, byrow = FALSE)
    dat_fosmo[61:80, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0039, 0.00668, 0.01578), each = 20),
                                                             ncol = 3, byrow = FALSE)
    dat_fosmo[81:100, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00504, 0.00863, 0.02037), each = 20),
                                                              ncol = 3, byrow = FALSE)
    dat_fosmo[101:120, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.00851, 0.01455, 0.03421), each = 20),
                                                               ncol = 3, byrow = FALSE)
    dat_fosmo[121:140, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.01318, 0.02249, 0.05258), each = 20),
                                                               ncol = 3, byrow = FALSE)
    dat_fosmo[141:160, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.0228, 0.03877, 0.08963), each = 20),
                                                               ncol = 3, byrow = FALSE)
    dat_fosmo[161:180, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.03957, 0.06686, 0.15156), each = 20),
                                                               ncol = 3, byrow = FALSE)
    dat_fosmo[181:N, c("mort1", "mort2", "mort3")] <- matrix(rep(c(0.07423, 0.12386, 0.2695), each = (N-180)),
                                                             ncol = 3, byrow = FALSE)
    
    dat_fosmo$stage_1[2:21] <- dat_fosmo$stage_1[1]*(1 - prog1_int - dat_fosmo$mort1[1])^(1:20)
    dat_fosmo$stage_1[22:41] <- dat_fosmo$stage_1[21]*(1 - prog1_int - dat_fosmo$mort1[21])^(1:20)
    dat_fosmo$stage_1[42:61] <- dat_fosmo$stage_1[41]*(1 - prog1_int - dat_fosmo$mort1[41])^(1:20)
    dat_fosmo$stage_1[62:81] <- dat_fosmo$stage_1[61]*(1 - prog1_int - dat_fosmo$mort1[61])^(1:20)
    dat_fosmo$stage_1[82:101] <- dat_fosmo$stage_1[81]*(1 - prog1_int - dat_fosmo$mort1[81])^(1:20)
    dat_fosmo$stage_1[102:121] <- dat_fosmo$stage_1[101]*(1 - prog1_int - dat_fosmo$mort1[101])^(1:20)
    dat_fosmo$stage_1[122:141] <- dat_fosmo$stage_1[121]*(1 - prog1_int - dat_fosmo$mort1[121])^(1:20)
    dat_fosmo$stage_1[142:161] <- dat_fosmo$stage_1[141]*(1 - prog1_int - dat_fosmo$mort1[141])^(1:20)
    dat_fosmo$stage_1[162:181] <- dat_fosmo$stage_1[161]*(1 - prog1_int - dat_fosmo$mort1[161])^(1:20)
    dat_fosmo$stage_1[182:N] <- dat_fosmo$stage_1[181]*(1 - prog1_int - dat_fosmo$mort1[181])^(1:(N-181))
    
    dat_fosmo$stage_2 <- dat_fosmo$stage_3 <- dat_fosmo$stage_4 <- dat_fosmo$death <- NA
    dat_fosmo$stage_2[2] <- dat_fosmo[1,"stage_1"]*prog1_int
    dat_fosmo$stage_2[3] <- dat_fosmo$stage_2[2]*(1 - prog2_int - dat_fosmo$mort2[1] - p_sev2*0.13883) + dat_fosmo[2,"stage_1"]*prog1_int
    ae_mort2_fosmo <- rep(NA, N)
    ae_mort2_fosmo[3:20] <- 0.13883
    ae_mort2_fosmo[21:40] <- 0.13798
    ae_mort2_fosmo[41:60] <- 0.13629
    ae_mort2_fosmo[61:80] <- 0.25503
    ae_mort2_fosmo[81:100] <- 0.25356
    ae_mort2_fosmo[101:120] <- 0.24908
    ae_mort2_fosmo[121:140] <- 0.31459
    ae_mort2_fosmo[141:160] <- 0.30298
    ae_mort2_fosmo[161:180] <- 0.28199
    ae_mort2_fosmo[181:N] <- 0.23529
    
    assign_stage_2_fosmo <- function(data, i) {
      data$stage_2[i + 1] <- data$stage_2[i]*(1 - prog2_int - data$mort2[i] - p_sev2*ae_mort2_fosmo[i]) + data$stage_1[i]*prog1_int
      data
    }
    for(i in 3:(N-1)) { dat_fosmo <- assign_stage_2_fosmo(dat_fosmo, i) }
    
    dat_fosmo$stage_3[2] <- 0
    dat_fosmo$stage_3[3] <- dat_fosmo$stage_2[2]*prog2_int
    ae_mort3_fosmo <- rep(NA, N)
    ae_mort3_fosmo[3:20] <- 0.13721
    ae_mort3_fosmo[21:40] <- 0.1352
    ae_mort3_fosmo[41:60] <- 0.13116
    ae_mort3_fosmo[61:80] <- 0.24813
    ae_mort3_fosmo[81:100] <- 0.24462
    ae_mort3_fosmo[101:120] <- 0.23379
    ae_mort3_fosmo[121:140] <- 0.29281
    ae_mort3_fosmo[141:160] <- 0.26404
    ae_mort3_fosmo[161:180] <- 0.21031
    ae_mort3_fosmo[181:N] <- 0.08281
    
    assign_stage_3_fosmo <- function(data, i) {
      data$stage_3[i+1] <- data$stage_3[i]*(1 - prog3_int - data$mort3[i] - p_sev3*ae_mort3_fosmo[i]) + data$stage_2[i]*prog2_int
      data
    }
    for(i in 3:(N-1)) { dat_fosmo <- assign_stage_3_fosmo(dat_fosmo, i) }
    
    dat_fosmo$stage_4[2] <- 0
    dat_fosmo$stage_4[3] <- dat_fosmo$stage_3[2]*prog3_int
    assign_stage_4_fosmo <- function(data, i) {
      data$stage_4[i+1] <- data$stage_4[i]*(1 - data$mort3[i] - p_sev4*ae_mort3_fosmo[i]) + data$stage_3[i]*prog3_int
      data
    }
    for(i in 3:(N-1)) { dat_fosmo <- assign_stage_4_fosmo(dat_fosmo, i) }
    
    dat_fosmo$death <- 100000 - rowSums(dat_fosmo[, c("stage_1", "stage_2", "stage_3", "stage_4")])
    
    dat_fosmo$QALY <- sapply(1:N, function(i) qaly(dat_fosmo, i))
    dat_fosmo$QALY[1] <- 0
    dat_fosmo$QALY_discounted <- dat_fosmo$QALY * discount_factor
    dat_fosmo$LYG <- rowSums(dat_fosmo[, c("stage_1", "stage_2", "stage_3", "stage_4")]) * cycle_length/12
    dat_fosmo$LYG[c(1, N)] <- 0
    dat_fosmo$LYG_discounted <- dat_fosmo$LYG * discount_factor
    
    dat_fosmo$costs <- costs_smo_new2(dat_fosmo, 1:N)
    dat_fosmo$costs[1] <- 0
    dat_fosmo$costs_discounted <- dat_fosmo$costs * discount_factor
    
    dat_fosmo$stage_1_ind_costs <- 0
    dat_fosmo$stage_2_ind_costs <- dat_fosmo$stage_2*(costs_stage2_stable + p_mod2*costs_stage2_mod_AE + p_sev2*costs_stage2_severe_AE)
    dat_fosmo$stage_3_ind_costs <- dat_fosmo$stage_3*(costs_stage3_stable + p_mod3*costs_stage3_mod_AE + p_sev3*costs_stage3_severe_AE)
    dat_fosmo$stage_4_ind_costs <- dat_fosmo$stage_4*(costs_stage4_stable + p_mod4*costs_stage4_mod_AE + p_sev4*costs_stage4_severe_AE)
    dat_fosmo$ind_costs <- rowSums(dat_fosmo[, c("stage_1_ind_costs","stage_2_ind_costs","stage_3_ind_costs","stage_4_ind_costs")], na.rm = TRUE)
    dat_fosmo$ind_costs_discounted <- dat_fosmo$ind_costs * discount_factor
    
    dat_fosmo$effects <- dat_fosmo$QALY_discounted / 100000
    
    ## Kumulative Effekte (Intervention vs. Standard Care)
    cycle_eff_int <- numeric(N)
    cycle_eff_int[1] <- dat_smo$effects[1]*(1-eff_int) + dat_fosmo$effects[1]*eff_int
    cycle_eff_int[2] <- cycle_eff_int[1] + dat_smo$effects[2]*(1-eff_int) + dat_fosmo$effects[2]*eff_int
    for(i in 2:(N-1)) {
      cycle_eff_int[i+1] <- cycle_eff_int[i] + dat_smo$effects[i+1]*(1-eff_int) + dat_fosmo$effects[i+1]*eff_int
    }
    cycle_eff_st <- numeric(N)
    cycle_eff_st[1] <- dat_smo$effects[1]*(1-eff_uc) + dat_fosmo$effects[1]*eff_uc
    cycle_eff_st[2] <- cycle_eff_st[1] + dat_smo$effects[2]*(1-eff_uc) + dat_fosmo$effects[2]*eff_uc
    for(i in 2:(N-1)) {
      cycle_eff_st[i+1] <- cycle_eff_st[i] + dat_smo$effects[i+1]*(1-eff_uc) + dat_fosmo$effects[i+1]*eff_uc
    }
    incr_eff <- cycle_eff_int - cycle_eff_st
    
    dat_smo$IKER <- (dat_smo$costs_discounted + dat_smo$ind_costs_discounted)/100000
    dat_fosmo$IKER <- (dat_fosmo$costs_discounted + dat_fosmo$ind_costs_discounted)/100000
    
    Costs_Int <- numeric(N)
    Costs_Int[1] <- (c_int + dat_smo$IKER[1]*(1-eff_int) + dat_fosmo$IKER[1]*eff_int)
    Costs_Int[2] <- Costs_Int[1] + dat_smo$IKER[2]*(1-eff_int) + dat_fosmo$IKER[2]*eff_int
    for(i in 2:(N-1)) {
      Costs_Int[i+1] <- Costs_Int[i] + dat_smo$IKER[i+1]*(1-eff_int) + dat_fosmo$IKER[i+1]*eff_int
    }
    dat_fosmo$Costs_Int <- Costs_Int
    
    ST <- numeric(N)
    ST[1] <- dat_smo$IKER[1]*(1-eff_uc) + dat_fosmo$IKER[1]*eff_uc
    ST[2] <- ST[1] + dat_smo$IKER[2]*(1-eff_uc) + dat_fosmo$IKER[2]*eff_uc
    for(i in 2:(N-1)) {
      ST[i+1] <- ST[i] + dat_smo$IKER[i+1]*(1-eff_uc) + dat_fosmo$IKER[i+1]*eff_uc
    }
    dat_fosmo$ST <- ST
    
    inkr_Kosten <- dat_fosmo$Costs_Int - dat_fosmo$ST
    ICER_Menn <- inkr_Kosten / incr_eff
    
    total_dir_costs_standard <- (sum(dat_smo$costs_discounted)/100000)*(1-eff_uc) +
      (sum(dat_fosmo$costs_discounted)/100000)*eff_uc + c_uc
    total_dir_costs_intervention <- (sum(dat_smo$costs_discounted)/100000)*(1-eff_int) +
      (sum(dat_fosmo$costs_discounted)/100000)*eff_int + c_int
    total_QALY_standard <- (sum(dat_smo$QALY_discounted)/100000)*(1-eff_uc) +
      (sum(dat_fosmo$QALY_discounted)/100000)*eff_uc
    total_QALY_intervention <- (sum(dat_smo$QALY_discounted)/100000)*(1-eff_int) +
      (sum(dat_fosmo$QALY_discounted)/100000)*eff_int
    
    list(
      dat_smo = dat_smo,
      dat_fosmo = dat_fosmo,
      ICER_Menn = ICER_Menn,
      total_dir_costs_standard = total_dir_costs_standard,
      total_dir_costs_intervention = total_dir_costs_intervention,
      total_QALY_standard = total_QALY_standard,
      total_QALY_intervention = total_QALY_intervention,
      cycle_eff_int = cycle_eff_int,
      cycle_eff_st = cycle_eff_st,
      incr_eff = incr_eff
    )
  })
  
  output$summaryText <- renderPrint({
    res <- simResults()
    dat_smo <- res$dat_smo
    dat_fosmo <- res$dat_fosmo
    cat("=== Raucher ===\n")
    cat("LYG (diskontiert) pro Patient:", round(sum(dat_smo$LYG_discounted)/100000, 4), "\n")
    cat("QALY (diskontiert) pro Patient:", round(sum(dat_smo$QALY_discounted)/100000, 4), "\n")
    cat("Kosten (diskontiert) pro Patient:", round(sum(dat_smo$costs_discounted)/100000, 2), "\n\n")
    
    cat("=== Ex-Raucher ===\n")
    cat("LYG (diskontiert) pro Patient:", round(sum(dat_fosmo$LYG_discounted)/100000, 4), "\n")
    cat("QALY (diskontiert) pro Patient:", round(sum(dat_fosmo$QALY_discounted)/100000, 4), "\n")
    cat("Kosten (diskontiert) pro Patient:", round(sum(dat_fosmo$costs_discounted)/100000, 2), "\n\n")
    
    cat("=== Direkte Kosten ===\n")
    cat("Standard Care:", round(res$total_dir_costs_standard, 2), "\n")
    cat("Intervention:", round(res$total_dir_costs_intervention, 2), "\n")
    cat("=== QALYs ===\n")
    cat("Standard Care:", round(res$total_QALY_standard, 4), "\n")
    cat("Intervention:", round(res$total_QALY_intervention, 4), "\n")
    cat("=== IKER (erste 10 Zyklen) ===\n")
    print(round(res$ICER_Menn[1:10], 2))
  })
  
  output$icerPlot <- renderPlot({
    res <- simResults()
    ICER_Menn <- res$ICER_Menn
    plot(ICER_Menn, type = "l", ylim = c(-20000, 50000), xlab = "Zyklus", ylab = "IKER (€/QALY)",
         main = "IKER über die Zeit", lwd = 2)
    axis(1, at = seq(0, length(ICER_Menn), 20))
    abline(h = seq(-20000, 50000, 10000), col = "gray", lty = 2)
  })
  
  output$stageDistribution <- renderPlot({
    res <- simResults()
    par(mfrow = c(1, 2))
    with(res$dat_smo, {
      plot(stage_1, type = "l", col = "green", xlab = "3-Monatszyklus", main = "Raucher", ylab = "Teilnehmer")
      lines(stage_2, col = "blue")
      lines(stage_3, col = "orange")
      lines(stage_4, col = "brown")
      lines(death, col = "black")
      legend("topright", legend = c("Stage I", "Stage II", "Stage III", "Stage IV", "Dead"),
             lty = 1, col = c("green", "blue", "orange", "brown", "black"), bty = "n")
    })
    with(res$dat_fosmo, {
      plot(stage_1, type = "l", col = "green", xlab = "3-Monatszyklus", main = "Ex-Raucher", ylab = "Teilnehmer")
      lines(stage_2, col = "blue")
      lines(stage_3, col = "orange")
      lines(stage_4, col = "brown")
      lines(death, col = "black")
      legend("topright", legend = c("Stage I", "Stage II", "Stage III", "Stage IV", "Dead"),
             lty = 1, col = c("green", "blue", "orange", "brown", "black"), bty = "n")
    })
  })
}

shinyApp(ui, server)
