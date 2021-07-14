# Postwork sesión 8. Dashboard de Shiny

#### OBJETIVO
- Ejecutar el código. 
- Observar el resultado de la toma de desiciones consecutivas, cuando estas se basan en datos históricos 

#### REQUISITOS
- Reproducir el código 
- Haber realizado los postworks previos 
- Analizar los gráficos resultantes

#### Instrucciones
Para este postwork genera un dashboard en un solo archivo `app.R`, para esto realiza lo siguiente: 
- Ejecuta el código `momios.R`
- Almacena los gráficos resultantes en formato `png` 
- Crea un dashboard donde se muestren los resultados con 4 pestañas:
- Una con las gráficas de barras, donde en el eje de las x se muestren los goles de local y visitante con un menu de selección, con una geometría de tipo barras además de hacer un facet_wrap con el equipo visitante
- Realiza una pestaña donde agregues las imágenes de las gráficas del postwork 3
- En otra pestaña coloca el data table del fichero `match.data.csv` 
- Por último en otra pestaña agrega las imágenes de las gráficas de los factores de ganancia mínimo y máximo

#### Desarrollo
1. Cargamos librerías
```r
library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
```
2. Construimos los elementos que se mostrarán en la aplicación
```r
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
                                            choices = c("Goles en casa","Goles de visita")),
                                
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
                                img( src = "momios_maximo.png"),
                                align="center"
                            )
                    )
                    
                )
            )
        )
    )
```
3. Construimos el código que se correrá en el servidor para alimentar con datos los distintos elementos de la aplicación
```r
server <- function(input, output) {
        # Lectura de dataset
        data <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-08/Postwork/match.data.csv")
        t_data <- table(data[c("home.score","away.score")])
        t_data <- as.data.frame(t_data)
        
    
        #Gráfico de barras
    output$plot1 <- renderPlot({
        
        #Decisión para graficar goles en casa o de visita
        if (input$x == "Goles en casa") {
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
```
4. Corremos la aplicación uniendo el frontend (ui) con el backend (server)
```r
shinyApp(ui, server)
```

### Visualización de la interfaz

Pestaña 1: Gráfica de goles en casa

![Tab1_graph1](https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/img/tab1_graph1.png)

Pestaña 1: Gráfica de goles de visita

![Tab1_graph2](https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/img/tab1_graph2.png)

Pestaña 2: Imágenes obtenidas en el Postwork 3

![Tab2](https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/img/tab2.png)

Pestaña 3: Data table del fichero `match.data.csv`

![Tab3](https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/img/tab3.png)

Pestaña 4: Gráficas de factores de ganancia

![Tab4](https://raw.githubusercontent.com/OmarGard/Bedu-F2-Postworks-E4/main/img/tab4.png)



