
# Lade die notwendigen Bibliotheken
library(shiny)
library(shinyjs)
library(lme4)
library(plotly)
library(haven)
library(gdata)
library(tidyr)
library(sp)

# UI der Shiny App
ui <- fluidPage(
  titlePanel("3D-Kontur-Plot für verschiedene Variablen in Relation zu FEV1 und Tiffeneau-Index"),
  
  sidebarLayout(
    sidebarPanel(
      # Auswahl der abhängigen Variable
      selectInput("response_var", 
                  "Abhängige Variable auswählen:",
                  choices = c("BMI_V1", "sum_comorb_all", "EXA_V1", "SGRQ_TOTAL_V1", "CAT_V1", "EQ5D_V1", "bode_gli_cat","FVC_GLI_PERCENT_PRED_V1"),
                  selected = "BMI_V1"),
      
      # Schieberegler für den Glättungsparameter
      sliderInput("span",
                  "Glättungsparameter (span) für LOESS:",
                  min = 0.1,
                  max = 1.5,
                  value = 0.75,
                  step = 0.05),
      
      checkboxInput("show_points", "Punkte anzeigen", value = TRUE)
    ),
    
    mainPanel(
      plotOutput("contourPlot"),
      textOutput("notes")
    )
  )
)

# Serverlogik der Shiny App
server <- function(input, output) {
  
  # Renderfunktion für den Konturplot
  output$contourPlot <- renderPlot({
    cosy1 <- read.csv2("S:\\AG_Holle\\TN\\Shiny_app\\5_contour_plot\\cosy_contour.csv")
    
    # Dynamisches LOESS-Modell unter Verwendung des gewählten response_var und span-Werts
    response_formula <- as.formula(paste(input$response_var, "~ FEV1_GLI_V1 * TIFF_V1"))
    data_loess <- loess(response_formula, data = cosy1, span = input$span)
    
    # Grid für FEV1 und Tiffeneau-Index erstellen
    xgrid_ <- seq(min(cosy1$FEV1_GLI_V1, na.rm = TRUE), max(cosy1$FEV1_GLI_V1, na.rm = TRUE), 1)
    ygrid_ <- seq(min(cosy1$TIFF_V1, na.rm = TRUE), max(cosy1$TIFF_V1, na.rm = TRUE), 0.01)
    data_fit <- expand.grid(FEV1_GLI_V1 = xgrid_, TIFF_V1 = ygrid_)
    
    # Vorhersagen mit LOESS-Modell erstellen
    mtrx3d_ <- predict(data_loess, newdata = data_fit)
    
    # Datenbereinigung
    cosy_clean <- na.omit(cosy1[, c("FEV1_GLI_V1", "TIFF_V1")])
    hull_idx <- chull(cosy_clean$FEV1_GLI_V1, cosy_clean$TIFF_V1)
    hull_coords <- cosy_clean[hull_idx, ]
    points_in_hull <- point.in.polygon(data_fit$FEV1_GLI_V1, data_fit$TIFF_V1,
                                       hull_coords$FEV1_GLI_V1, hull_coords$TIFF_V1)
    mtrx3d_[points_in_hull == 0] <- NA
    
    # Kontur-Plot
    contour(x = xgrid_, y = ygrid_, z = mtrx3d_,
            xlab = "FEV1_GLI_V1", ylab = "TIFF_V1",
            main = paste("Association between", input$response_var, "(isoquants),\nFEV1 (%pred.) and Tiffeneau index"))
    # Only show points if checkbox is selected
    if (input$show_points) {
      points(cosy1$FEV1_GLI_V1, cosy1$TIFF_V1, pch=".", cex=2) 
    }
  })
  
  output$notes <- renderText({"Hinweise: \n 1. Basierend auf 2701 COSYCONET-Teilnehmern (2741 minus 40 'ohne COPD'),\n2. beschränkt auf die FEV1- und Tiff.-Bereiche, in denen es Beobachtungen gab.\nAutor: Tobias Niedermaier. Zuletzt geändert: 9.12.2024."})
}

# Shiny App starten
shinyApp(ui = ui, server = server)
