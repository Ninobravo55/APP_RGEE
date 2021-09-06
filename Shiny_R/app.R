#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
# www.geomatica.pe
# ----------------------------------------------------------------------

# Descargar GIT y registrarse
# Dirección para descargar Git: https://git-scm.com/downloads 
# Dirección para registrar el usuario en GitHub: https://github.com

# ---------------------------------------------------------------------
# Configurar GIT su usuario y correo en el terminal
#git config --global user.name "Ninobravo55"
#git config --global user.email "geoambiental2030@gmail.com"

# ---------------------------------------------------------------------

# Activamos libreria GEE
#library(reticulate)
#library(rgee)
#library(googledrive)

# App GEE
library(shiny)
library(lubridate)
library(readxl)

# ------------------------------------------------------------------------

# Cargamos un archivo excel - lista provincia Peru - Dentro proyecto
Lista_Provincia <- read_excel("Lista_Provincia_Excel.xlsx")

# Seleccionamos los nombre provincia
nom_prov = Lista_Provincia$NOMBPROV

# ------------------------------------------------------------------------
# Agregamos un featurecollection de GEE

# Iniciar sesion RGEE

# ee_Initialize("bravomoralesnino@gmail.com", drive = T) # Activa drive

# Agregar un featurecollection de limite Provincia Peru
#limite_provincia = ee$FeatureCollection('users/bravomoralesnino/Tabla/Limite_Provincia')


# -----------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Aplicativo en Google Earth Engine"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            

            # Seleccione satelite
            selectInput(inputId = "Satelite_input",
                        label = "Seleccione satelite",
                        choices = c("Landsat_5"="LANDSAT/LT05/C01/T1_SR","Landsat_8"="LANDSAT/LC08/C01/T1_SR")),
            
            # Seleccionar rango de fecha
            dateRangeInput("rango_fechas_input",
                           h3("Rango de Fechas"),
                           language = "es",
                           format = "yyyy-mm-dd",
                           start = "1900-01-01",
                           end = today()-30,
                           separator = " a "),
            
            # Seleccione el porcentaje de nubosidad
            numericInput("nube_input","Ingrese porcentaje nubosidad",           
                         min = 0,
                         max = 100,
                         step = 5,
                         value = 20),
            
            # Seleccione provincia
            selectInput(inputId="provincia_input",label="Seleccione Provincia",
                        choices = nom_prov, selected = "LEONCIO PRADO",multiple = F),
            
            # Seleccione la composicion bandas
            selectInput(inputId = "R_input",
                        label = "Seleccione Composicion bandas",
                        choices = c("B1"="B1","B2"="B2","B3"="B3","B4"="B4","B5"="B5","B6"="B6","B7"="B7")),
            
            # Boton de ejecutar cambio
            submitButton("Ejecutar"),
            
            # Boton de salir
            actionButton("salir_input","Salir"),
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h3("Seleccion del satelite:"),
            verbatimTextOutput("satelite_otput"),
            h3("Seleccione rango fecha:"),
            verbatimTextOutput("rango_fecha_otput"),
            h3("Seleccion porcenaje nubosidad:"),
            verbatimTextOutput("nubosidad_otput"),
            h3("Seleccion de la provincia:"),
            verbatimTextOutput("provincia_otput"),
            h3("Seleccion composicion bandas:"),
            verbatimTextOutput("R_otput"),
            h3("Salida de informacion:"),
            verbatimTextOutput("salida_otput"),
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Seleccion imagen colleccion por satelite
    output$satelite_otput <- renderPrint({
        satelite <- input$Satelite_input
        print(satelite)
    })
    
    # Filtro de fecha de las imagenes collection
    output$rango_fecha_otput <- renderPrint({
        fecha_tex <- as.character(input$rango_fechas_input)
        fecha_inicial <- fecha_tex[1]
        fecha_final <- fecha_tex[2]
        print(fecha_inicial)
        print(fecha_final)
    })
    
    # Filtro de porcentaje de nubosidad
    output$nubosidad_otput <- renderPrint({
        nube <- input$nube_input
        print(nube)
    })
    
    # Filtro por zona de estudio
    output$provincia_otput <- renderPrint({
        Provincia <- input$provincia_input
        print(Provincia)
        
    })

    # Selecciona composicion de bandas
    output$R_otput <- renderPrint({
        R <- input$R_input
        print(R)
    })  
    
    
    # Salida del proyecto
    output$salida_otput <- renderPrint({
        salida <- input$salir_input
        print(salida)
    })
    
    
}

# Ejecutar la aplicacion 
shinyApp(ui = ui, server = server)
