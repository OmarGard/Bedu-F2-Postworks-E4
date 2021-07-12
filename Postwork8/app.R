#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)

ui <- 
    
    fluidPage(
        
        dashboardPage(
            skin = "yellow",
            dashboardHeader(title = "Liga española"),
            
            dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Gráfica de goles", tabName = "goles",icon = icon("futbol")),
                    menuItem("Probabilidades", tabName = "graph", icon = icon("dice")),
                    menuItem("Tabla de datos", tabName = "data_table", icon = icon("table")),
                    menuItem("Factores de ganancia", tabName = "img", icon = icon("image"))
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    #Gráfica de barras
                    tabItem(tabName = "goles",
                            fluidRow(
                                titlePanel("Gráfica de goles de casa y de visita"), 
                                selectInput("x", "Seleccione algún valor:",
                                            choices = names(t_data[-3])),
                                
                                box(plotOutput("plot1", width = 600)),
                                align = "center"
                            )
                    ),
                    
                    # Imagenes de Postwork 3
                    tabItem(tabName = "graph", 
                            fluidRow(
                                titlePanel(h3("Probabilidades marginales")),
                                img(src = "Postwork3(1).png", height = 300, width = 300),
                                img(src = "Postwork3(2).png", height = 300, width = 300),
                                titlePanel(h3("Mapa de calor de probabilidades conjuntas")),
                                img(src = "Postwork3(3).png",align="center"), 
                                align="center"
                            )
                    ),
                    
                    
                    #Fichero
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    ), 
                    
                    #
                    tabItem(tabName = "img",
                            fluidRow(
                                titlePanel(h3("Escenario con momios promedio")),
                                img( src = "momios_promedio.png"),
                                titlePanel(h3("Escenario con momios máximo")),
                                img( src = "momios_maximo.png")
                            )
                    )
                    
                )
            )
        )
    )


server <- function(input, output) {
        # Lectura de dataset
        data <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-08/Postwork/match.data.csv")
        t_data <- table(data[c("home.score","away.score")])
        t_data <- as.data.frame(t_data)
        
    
        #Gráfico de barras
    output$plot1 <- renderPlot({
        
        #Decisión para graficar goles en casa o de visita
        if (input$x == "home.score") {
            ggplot(t_data, aes(home.score, Freq)) +
                geom_bar(stat = "identity", color ="black", fill="blue") +
                facet_wrap(~away.score) +
                labs(y="Frecuencia", x= "Goles en casa", title = "Goles de visita") +
                theme_bw() +
                theme(title = element_text(size=18))
        }else{
            ggplot(t_data, aes(away.score, Freq)) +
                geom_bar(stat = "identity", color ="black", fill="red") +
                facet_wrap(~away.score) +
                labs(y="Frecuencia", x="Goles de visita", title = "Goles de visita") +
                theme_bw() +
                theme(title = element_text(size=18), )
        }
        
    })
    
    #Data Table
    output$data_table <- renderDataTable({data}, options = list(aLengthMenu = c(5,25,50), iDisplayLength = 8))
    
}


shinyApp(ui, server)

