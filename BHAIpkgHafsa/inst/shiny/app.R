
# Load required packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
library(BHAIpkgHafsa)

# Load packaged data
data("healthcare_associated_infections", package = "BHAIpkgHafsa")

# UI ----
ui <- fluidPage(
  theme = shinytheme("flatly"),

  # Custom CSS styling
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&display=swap"),
    tags$style(HTML("
      body {
        background-color: #eef2f7;
        font-family: 'Open Sans', sans-serif;
      }
      .app-header {
        margin-top: 15px;
        margin-bottom: 20px;
        background-color: #003366;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0px 3px 6px rgba(0,0,0,0.15);
      }
      .panel-desc {
        background: #ffffff;
        padding: 12px;
        border-radius: 8px;
        box-shadow: 0px 1px 3px rgba(0,0,0,0.1);
      }
      .sidebar {
        background-color: #ffffff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0px 3px 6px rgba(0,0,0,0.1);
      }
      .main-panel {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0px 3px 6px rgba(0,0,0,0.1);
      }
      h4 {
        color: #003366;
        font-weight: 600;
      }
      .plotly html-widget {
        background-color: #ffffff;
        border-radius: 10px;
      }
    "))
  ),

  # App title header
  div(class = "app-header",
      h2("HAI (Healthcare Associated Infections) Burden Explorer — by Infection Type")
  ),

  # Layout ----
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      selectInput("infection", "Select infection type (or All):",
                  choices = c("All", sort(unique(healthcare_associated_infections$Infection_Type))),
                  selected = "All"),

      radioButtons("metric", "Metric to display:",
                   choices = c("Number of HAIs" = "Number_of_HAIs",
                               "Number of attributable deaths" = "Number_of_attributable_deaths"),
                   selected = "Number_of_HAIs"),

      checkboxInput("show_table", "Show summary table", value = TRUE),
      hr(),
      h5("Fields explanation:"),
      div(class = "panel-desc",
          p(strong("Infection_Type:"),
            "The category of healthcare-associated infection (e.g., BSI, HAP, UTI, SSI, CDI)."),
          p(strong("Number_of_HAIs:"),
            "The estimated total number of infection cases occurring in healthcare settings by each infection type."),
          p(strong("Number_of_attributable_deaths:"),
            "The estimated number of deaths directly caused by each infection type.")
      )
    ),

    mainPanel(
      class = "main-panel",
      h4("Interactive Plot: HAI Burden by Infection Type"),
      plotlyOutput("hai_plot", height = "420px"),
      br(),
      uiOutput("interpretation"),
      br(),
      conditionalPanel(
        condition = "input.show_table == true",
        h4("Summary Table"),
        tableOutput("summary_table")
      )
    )
  )
)

# SERVER ----
server <- function(input, output, session) {

  # Reactive filtering ----
  filtered <- reactive({
    df <- healthcare_associated_infections
    if (input$infection != "All") df <- df[df$Infection_Type == input$infection, ]
    df
  })

  # Reactive summary ----
  summary_df <- reactive({
    filtered() %>%
      group_by(Infection_Type) %>%
      summarise(
        records = n(),
        total_HAIs = sum(Number_of_HAIs, na.rm = TRUE),
        mean_HAIs = mean(Number_of_HAIs, na.rm = TRUE),
        total_deaths = sum(Number_of_attributable_deaths, na.rm = TRUE),
        mean_deaths = mean(Number_of_attributable_deaths, na.rm = TRUE)
      ) %>%
      arrange(desc(total_HAIs))
  })

  # Interactive Plotly chart ----
  output$hai_plot <- renderPlotly({
    summ <- summary_df()
    metric <- input$metric
    y <- if (metric == "Number_of_HAIs") summ$total_HAIs else summ$total_deaths

    p <- ggplot(summ, aes(
      x = reorder(Infection_Type, -y),
      y = y,
      fill = Infection_Type,
      text = paste0(
        "<b>Infection type:</b> ", Infection_Type, "<br>",
        if (metric == "Number_of_HAIs") "<b>Total HAIs:</b> " else "<b>Total deaths:</b> ", y
      )
    )) +
      geom_col(show.legend = FALSE, width = 0.7) +
      scale_fill_viridis_d(option = "plasma", direction = -1) +
      labs(
        x = "Infection Type",
        y = if (metric == "Number_of_HAIs") "Total HAIs" else "Total Attributable Deaths"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, color = "#003366"),
        axis.text.y = element_text(color = "#003366"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank()
      )

    ggplotly(p, tooltip = "text") %>%
      layout(hoverlabel = list(bgcolor = "white", font = list(size = 13)))
  })

  # Summary table ----
  output$summary_table <- renderTable({
    summary_df()
  }, digits = 0)

  # Interpretation text ----
  output$interpretation <- renderUI({
    metric_label <- if (input$metric == "Number_of_HAIs") "total HAI events" else "total attributable deaths"
    HTML(paste0("<b>How to interpret the plot:</b><br>",
                "Bars show the ", metric_label, " aggregated by infection type. ",
                "Hover your cursor over the bars to view details. ",
                "Higher bars indicate infection types with greater burden. ",
                "Use the selector to focus on a single infection type or 'All' to compare across types."))
  })
}

# Run the Shiny App ----
shinyApp(ui, server)

