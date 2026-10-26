library("shiny")
library("shinydashboard")
library("move2")
library("stringr")
library("sf")

library(rsconnect)
library(maps)
library(ggmap)
library(sf)
library(geosphere)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(shiny)
library(shinycssloaders)
library(shinyFeedback)
library(bslib)
library(DT)
library(rgl)
library(htmlwidgets)

library(ctmm)

#remotes::install_github("smach/rcolorutils", build_vignettes = TRUE)
library(rcolorutils)

options(shiny.maxRequestSize=200*1024^2)

source("data/auxiliary/local-files/provided-app-files/ctmmRayshader.r")


# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the src/common/logger.R file:
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

shinyModuleUserInterface <- function(id, label) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- NS(id)
  # showcase to access a file ('auxiliary files') that is 
  # a) provided by the app-developer and 
  # b) can be overridden by the workflow user.
  #fileName <- getAuxiliaryFilePath("auxiliary-file-a")
  
  dashboardPage(
    skin = "blue",
    dashboardHeader(title = "Animal Tracking Data ctmm Visualizer"),
    
    dashboardSidebar(
      sidebarMenu(
        #menuItem("Examples", tabName = "examples", icon = icon("globe")),
        menuItem("ctmmRayshader Examples", tabName = "ctmmRayshader_examples", icon = icon("globe")),
        #menuItem("Upload & Visualize", tabName = "upload_visual", icon = icon("upload")),
        menuItem("ctmmRayshader Upload & Visualize", tabName = "ctmmRayshader_upload_visual", icon = icon("upload"))
      )
    ),
    
    dashboardBody(
      useShinyFeedback(),  # for inline input validation
      tabItems(
        
        
        
        
        # --- ctmmRayshader Examples Tab ---
        # example 1: summer multiple akde nutcrackers with sun circle shadows and widget
        # example 2: winter single akde with data nutcrackers with rotation animation and widget
        # example 3: summer path animation with tucans and widget
        # example 4: no landsat data
        tabItem(tabName = "ctmmRayshader_examples",
                fluidRow(
                  box(title = "Example Settings", width = 12, solidHeader = TRUE, status = "info",
                      helpText("Below are some examples of ctmmRayshader.")),
                  box(title = "Choose an example!", width = 4, solidHeader = TRUE, status = "info",
                      helpText("Add help text for the examples
                             "),
                      selectInput(ns("exampleRayshader"), "Choose Example:", choices = c("Rayshader Example 1","Rayshader Example 2"))
                      #downloadButton("downloadKMLExample", "Download Generated KML", class = "btn-primary")
                      
                  ),
                  box(
                    width = 6,
                    title = "3D Rayshader Plot",
                    solidHeader = TRUE,
                    status = "success",
                    uiOutput(ns("ctmmRayshader_rglwidget"))
                  ),
                  box(title = "Examples", width = 12, solidHeader = TRUE, status = "primary",
                      # tags$h3(""),
                      uiOutput(ns("ctmmRayshader_example_video"))
                  )
                )
        ),
        
        # --- Examples Tab ---
        # tabItem(tabName = "examples",
        #         fluidRow(
        #           box(title = "Example Settings", width = 12, solidHeader = TRUE, status = "info",
        #               helpText("Welcome to the ctmm visualization webapp! Below are examples of both different methods of visulzation, ctmmEarth and ctmmRayshader.")),
        #           box(title = "Choose an example!", width = 4, solidHeader = TRUE, status = "info",
        #               helpText("Below are three examples of what customization
        #                      options look like for a single dataset. Example 1 is 
        #                      the simplest overhead view of the animal as it moves 
        #                      forward through time. Example two is with different cosmetic options,
        #                      and as shown in the video is from the point of view (POV) of the animal.
        #                      Example 3 shows another example with different cosmetic options, but using the manual camera,
        #                      a mode where you can set in Google Earth Pro where you want the camera to look
        #                      "),
        #               selectInput("example", "Choose Example:", choices = c("Example 1", "Example 2", "Example 3")),
        #               downloadButton("downloadKMLExample", "Download Generated KML", class = "btn-primary")
        #               
        #           ),
        #           box(title = "Example Output", width = 8, solidHeader = TRUE, status = "primary",
        #               withSpinner(plotlyOutput("pathPlot"), type = 6)
        #           ),
        #           box(title = "Example Output Visulazied with Precustomization", width = 12, solidHeader = TRUE, status = "primary",
        #               # tags$h3(""),
        #               uiOutput("example_video")
        #           )
        #         )
        # ),
        
        # --- Upload Tab ---
        # tabItem(tabName = "upload_visual",
        #         fluidRow(
        #           box(title = "Upload Tracking Data", width = 4, solidHeader = TRUE, status = "primary",
        #               helpText("Upload your CSV and (optional) CTMM Model for KML simulation."),
        #               fileInput("file", "Upload CSV File"),
        #               fileInput("kmlfile", "Choose Existing KML (Optional)"),
        #               selectInput("plotType", "Do you have a CTMM Model?", choices = c("Yes", "No")),
        #               conditionalPanel(
        #                 condition = "input.plotType == 'Yes'",
        #                 fileInput("Model_Object", "Upload CTMM Model RData")
        #               ),
        #               actionButton("submit", "Generate KML", class = "btn-success")
        #           ),
        #           
        #           box(title = "Visualization Options", width = 4, solidHeader = TRUE, status = "info",
        #               numericInput("Duration", "Duration (s):", 60, min = 10),
        #               numericInput("sequencetime", "Sequence Time (s):", 5),
        #               numericInput("SimulationNumber", "Number of Simulations:", 5),
        #               selectInput("SimulationColor_upload", "Simulation Color:", c( "Red", "Blue", "Green")),
        #               selectInput("PredictColor", "Prediction Color:", c("Red", "Blue", "Green")),
        #               checkboxInput("AnimalIcon", "Use Animal Icons?", value = TRUE),
        #               checkboxInput("SimulationIcon", "Show Simulation Icons?", value = TRUE),
        #               checkboxInput("ErrorCircle", "Show Error Circle?", value = TRUE),
        #               checkboxInput("POVCam", "Use POV Camera?", value = FALSE),
        #               checkboxInput("FollowCam", "Follow Camera?", value = TRUE)
        #           ),
        #           
        #           box(title = "KML Output", width = 4, solidHeader = TRUE, status = "primary",
        #               br(),
        #               downloadButton("downloadKML", "Download Generated KML", class = "btn-primary")
        #           )
        #         ),
        #         
        #         fluidRow(
        #           box(title = "Map Visualization", width = 12, solidHeader = TRUE, status = "primary",
        #               withSpinner(plotlyOutput("uploadPlot"), type = 6)
        #           )
        #         )
        # ),
        
        
        tabItem(tabName = "ctmmRayshader_upload_visual",
                fluidRow(
                  box(title = "Upload Tracking Data", width = 12, solidHeader = TRUE, status = "primary",
                      helpText("Upload your CSV and (optional) CTMM Model for KML simulation."),
                      #conditionalPanel(
                      selectInput(ns("data_type"), "What format is your data in?", choices = c("Movebank CSV", "CTMM telematry")),
                      
                      conditionalPanel(
                        condition = paste0("input['", ns("data_type"), "'] == 'Movebank CSV'"),
                        fileInput(ns("movebank_file"), "Upload CSV File"),
                        #DT::DTOutput("ctmmRayshader_files")
                      ),
                      conditionalPanel(
                        condition = paste0("input['", ns("data_type"), "'] == 'CTMM telematry'"),
                        fileInput(ns("telematry_file"), "Upload telematry File"),
                        #DT::DTOutput("ctmmRayshader_files")
                      ),
                      selectInput(ns("FIT_models"), "Do you have a CTMM Model?", choices = c("Yes", "No")),
                      conditionalPanel(
                        condition = paste0("input['", ns("FIT_models"), "'] == 'Yes'"),
                        fileInput(ns("ctmmRayshader_upload"), "Upload CTMM Models RData", multiple=TRUE),
                        #DT::DTOutput("ctmmRayshader_files")
                      ),
                      conditionalPanel(
                        condition = paste0("input['", ns("FIT_models"), "'] == 'No'"),
                        uiOutput(ns("names_csv")),
                        uiOutput(ns("names_teml"))
                        
                      )
                  ),
                  
                  
                  box(title="Color Selection", width=6,
                      selectInput(ns("viewColors"), "Do you want to view color options", choices = c("Yes", "No")),
                      selectInput(
                        inputId = ns("color_selections"),
                        label = "Select Colors:",
                        choices = c("Grays", "Light Grays", "Blues 2", "Blues 3", "Purples 2",
                                    "Purples 3"," Reds 2", "Reds 3", "Greens 2", "Greens 3"," Oslo",
                                    "Purple-Blue", "Red-Purple", "Red-Blue", "Purple-Orange", "Purple-Yellow", "Blue-Yellow", "Green-Yellow",
                                    "Red-Yellow", "Heat", "Heat 2", "Terrain", "Terrain 2", "Viridis", "Plasma", "Inferno", "Rocket", "Mako", "DarkMint", "Mint", "BluGrn", "Teal", "TealGrn", "Emrld", "BluYl", "ag_GrnYl", "Peach", "PinkYl", "Burg", "BurgYl", "RedOr",
                                    "OrYel", "Purp", "PurpOr", "Sunset", "Magenta", "SunsetDark", "ag_Sunset", "BrwnYl", "YlOrRd", "YlOrBr", "OrRd",
                                    "Oranges", "YlGn", "YlGnBu", "Reds", "RdPu", "PuRd", "Purples", "PuBuGn", "PuBu", "Greens", "BuGn", "GnBu", "BuPu",
                                    "Blues", "Lajolla", "Turku", "Hawaii", "Batlow"), # Optional: set initial selections
                        multiple = TRUE # This is the key for multi-selection
                      ),
                      conditionalPanel(
                        #condition = "input.viewColors == 'Yes'",
                        paste0("input['", ns("viewColors"), "'] == 'No'"),
                        plotOutput(ns("colorOutput"))
                      )
                  ),
                  
                  box(title="Selected Colors", width=6,plotOutput(ns("colorPlot"))),
                  box(title = "Visualization Options", width = 12, solidHeader = TRUE, status = "info",
                      
                      numericInput(ns("padding"), "buffer around plot", .05),
                      numericInput(ns("upscale_factor"), "Resolution Upscale factor", 1),
                      selectInput(ns("season"), "Select a season", c("summer", "fall", "winter","spring","all")),
                      checkboxInput(ns("sim_path"), "Plot simulated path(s)", value = FALSE),
                      checkboxInput(ns("AKDE"), "Plot AKDE(s)", value = TRUE),
                      checkboxInput(ns("show_data"), "Plot data points", value = TRUE),
                      checkboxInput(ns("animate_shadows"), "make animation of shadows", value = FALSE),
                      checkboxInput(ns("spin_animation"), "make animation of rotating spining model", value = FALSE),
                      numericInput(ns("animation_duration"), "Duration of animation", 30),
                      #textAreaInput("AKDE_color_list", "Enter one color pallet per line:"),
                      actionButton(ns("parameters_submit"),"submit parameters")
                  ),
                  
                  box(title="Landsat settings", width=6, solidHeader = TRUE,
                      numericInput(ns("stretch_min"), "landsat plotting stretch min", .001),
                      numericInput(ns("stretch_max"), "landsat plotting stretch max", .999),
                      numericInput(ns("shadow_intesity"), "Shadow intensity from 0 to 1", .5),
                      actionButton(ns("viewLandsat"),"view landsat"),
                      actionButton(ns("run_plotRayshader"),"run ctmmRayshader")
                  ),
                  
                  box(title="Landsat display",
                      plotOutput(ns("landsatRaster"))),
                  
                  
                  box(title = "ctmmRayshader output", width = 6, solidHeader = TRUE, status = "primary",
                      rglwidgetOutput(ns("rgl_rayshader_plot"))
                      ,downloadButton(ns("downloadWidget"), "Download 3D model", class = "btn-primary")
                  ),
                  box(title = "Animation", width = 6, solidHeader = TRUE, status = "primary",
                      uiOutput(ns("ctmmRayshader_animation")),
                      downloadButton(ns("downloadVideo"), "Download animation", class = "btn-primary")
                  )
                  
                )
                # ),
                # 
                # fluidRow(
                #   box(title = "Map Visualization", width = 12, solidHeader = TRUE, status = "primary",
                #       withSpinner(plotlyOutput("uploadPlot"), type = 6)
                #   )
                # )
        )
      )
    ),
    title = "Animal Tracking KML Viewer"
  )
}

# The parameter "data" is reserved for the data object passed on from the previous app
shinyModule <- function(input, output, session, data=NULL) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- session$ns
  current <- reactiveVal(data)
 
  output$colorOutput=renderPlot({
    hcl_palettes("sequential", n = 7, plot = TRUE)
  })
  # output$selected_items <- renderPrint({
  #   length(input$color_selections)
  # })
  # 
  observe({
    req(input$color_selections)
    palettes=c()
    for(palette in input$color_selections){
      palettes=append(palettes, sequential_hcl(n=5, palette))
    }
    
    output$colorPlot=renderPlot({
      if(length(input$color_selections)>=1){
        plotCol(palettes, nrow=length(input$color_selections))
      }
    })
  })
  
  
  df_csv <- reactive({
    req(input$movebank_file)
    read.csv(input$movebank_file$datapath)
  })
  df_telm <- reactive({
    req(input$telematry_file)
    readRDS(input$telematry_file$datapath)
  })
  
  
  output$names_teml <- renderUI({
    req(input$telematry_file)
    print("I am here------------------------")
    if(class(df_telm())=="telemetry"){
      selectInput(
        inputId = ns("individuals"),
        label = "Select individuals:",
        choices = df_telm()@info$identity,
        multiple = TRUE
      )
    }else{
      selectInput(
        inputId = ns("individuals"),
        label = "Select individuals:",
        choices = sort(names(df_telm())),
        multiple = TRUE
      )
    }
    
  })
  
  output$names_csv <- renderUI({
    req(input$movebank_file)
    print("I am here :)")
    selectInput(
      inputId = ns("individuals"),
      label = "Select individuals:",
      choices = sort(unique(df_csv()$individual.local.identifier)),
      multiple = TRUE
    )
  })
  
  
  FIT_list=reactive({
    if (input$FIT_models == "Yes") {
      FITs <- list()
      for (model_path in input$ctmmRayshader_upload$datapath) {
        load(model_path)  # assumes FIT is defined inside
        FITs <- append(FITs, list(FIT))
      }
      return(FITs)
    } else {
      NULL
    }
  })
  
  
  
  individuals_from_models <- reactive({
    req(input$ctmmRayshader_upload)
    ids <- c()
    for (fit in FIT_list()) {
      ids <- append(ids, fit@info$identity)
    }
    return(ids)
  })
  
  

  
  individuals <- reactive({
    if (input$FIT_models == "Yes") {
      individuals_from_models()
    } else {
      input$individuals
    }
  })
  
  
  
  
  padding <- reactive({ input$padding })
  upscale_factor <- reactive({ input$upscale_factor })
  season <- reactive({ input$season })
  sim_path <- reactive({ input$sim_path })
  AKDE <- reactive({ input$AKDE })
  show_data <- reactive({ input$show_data })
  animate_shadows <- reactive({ input$animate_shadows })
  spin_animation <- reactive({input$spin_animation})
  animation_duration<- reactive({input$animation_duration})
  
  AKDE_color_list <- reactive({input$color_selections})
  
  observeEvent(input$parameters_submit, {
  
    print("---------")
    print(individuals())
    print("---------")
    shiny::withProgress(
      message = paste0("Running part_1"),
      value = 0,
      {
        shiny::incProgress(1/10)
        Sys.sleep(1)
        shiny::incProgress(5/10)
        
        df <- reactive({
          if (isTruthy(input$telematry_file)) {
            df_telm()
          } else if (isTruthy(input$movebank_file)) {
            df_csv()
          } else {
            NULL
          }
        })
       

        part_1_stuff=part_1(
          individuals= individuals(),
          df=df(),
          FIT_list=FIT_list(),
          padding =padding(),
          season=season(),
          sim_path=sim_path(),
          AKDE=AKDE(),
          Upscale_factor=upscale_factor()
        )
      })
    
    
    
    stretch_min <- reactive({ req(input$stretch_min); input$stretch_min })
    stretch_max <- reactive({ req(input$stretch_max); input$stretch_max })
    stretch <- reactive({ c(stretch_min(), stretch_max()) })
    shadow_intesity <- reactive({ input$shadow_intesity })
    
    observeEvent(input$viewLandsat,{
      hillshade=make_hillshade(landsat_rgb_cropped=part_1_stuff$landsat,
                               elevation_cropped=part_1_stuff$elvation,
                               akde_list=part_1_stuff$akde_list,
                               combined_CI=part_1_stuff$combined_CI,
                               AKDE_color_list=isolate(AKDE_color_list()),
                               AKDE=isolate(AKDE()),
                               sunangle=50,
                               shadow_intesity=isolate(shadow_intesity()),
                               stretch=isolate(stretch()))
      tiff_image <- brick("data/auxiliary/local-files/provided-app-files/landsat_with_overlay.tiff")
      output$landsatRaster=renderPlot(plotRGB(tiff_image))
    })
    
    observeEvent(input$run_plotRayshader,{
      shiny::withProgress(
        message = paste0("Running ctmmRayshader"),
        value = 0,
        {
          shiny::incProgress(1/10)
          Sys.sleep(1)
          shiny::incProgress(5/10)
          
          
          
          plot_rayshader(
            #individuals = individuals(),
            individuals=isolate(individuals()),
            df=isolate(df()),
            FIT_list=isolate(FIT_list()),
            sim_path=isolate(sim_path()), 
            AKDE=isolate(AKDE()),
            AKDE_color_list = isolate(AKDE_color_list()),
            show_data = isolate(show_data()),
            padding =isolate(padding()),
            animate_shadows=isolate(animate_shadows()),
            spin_animation=isolate(spin_animation()),
            season=isolate(season()),
            shadow_intesity=isolate(shadow_intesity()),
            stretch=isolate(stretch()),
            part_1_stuff=part_1_stuff,
            animation_duration=isolate(animation_duration()),
            Upscale_factor=upscale_factor())
          
          
          #widget=rglwidget()
        })
      
      
      # output$rgl_rayshader_plot <- renderRglwidget({
      #   widget
      # })
      # 
      # output$downloadWidget <- downloadHandler(
      #   filename = function() {
      #     "rglWidget.html"
      #   },
      #   content = function(file) {
      #     shiny::withProgress(
      #       message = paste0("Downloading rglWidget html file"),
      #       value = 0,
      #       {
      #         shiny::incProgress(1/10)
      #         Sys.sleep(1)
      #         shiny::incProgress(5/10)
      #         saveWidget(
      #           widget,
      #           file = file,
      #           selfcontained = TRUE 
      #         )
      #       }
      #     )
      #     
      #   }
      # )
      
      observe({
        req(input$spin_animation==TRUE)
        output$ctmmRayshader_animation=renderUI({
          tags$video(
            src = "Rayshader_spin_animation.mp4",
            width = "1200px",
            height = "1080px",
            frameborder = "0",
            allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
            allowfullscreen = NA
          )
        })
        output$downloadVideo <- downloadHandler(
          filename = function() {
            "Rayshader_spin_animation.mp4"
          },
          content = function(file) {
            shiny::withProgress(
              message = paste0("Downloading .mp4 file"),
              value = 0,
              {
                shiny::incProgress(1/10)
                Sys.sleep(1)
                shiny::incProgress(5/10)
                file.copy("www/Rayshader_spin_animation.mp4", file)
              }
            )
            
          }
        )
      })
    })
    
  })
  
  
  
  # bundle all JS/CSS inside one file
  
  
  # observe({
  #   print("5")
  #   req(input$parameters_submit)
  #   if(length(class(individuals))>1){
  #     individuals=individuals
  #   }
  #   output$rgl_rayshader_plot <- renderRglwidget({
  #     plot_rayshader(
  #       individuals = individuals(),
  #       df=df,
  #       FIT_list=FIT_list,
  #       sim_path=sim_path, 
  #       AKDE=AKDE,
  #       AKDE_color_list = AKDE_color_list(),
  #       show_data = show_data,
  #       padding =padding,
  #       animate_shadows=animate_shadows,
  #       season=season,
  #       shadow_intesity=shadow_intesity,
  #       stretch=stretch)
  #     
  #     rglwidget()
  #   })
  # })
  
  
  output$ctmmRayshader_example_video = renderUI({
    if (input$exampleRayshader == "Rayshader Example 1") {
      tags$iframe(
        #src = "https://youtube.com/embed/MDZI0jJtkq4",
        src = "https://youtube.com/embed/ze5ixvRnIkM",
        width = "1200px",
        height = "1080px",
        frameborder = "0",
        allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
        allowfullscreen = NA
      )
    }else if(input$exampleRayshader == "Rayshader Example 2") {
      tags$iframe(
        src = "https://youtube.com/embed/kqdS7tWLtXU",
        width = "1200px",
        height = "1080px",
        frameborder = "0",
        allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
        allowfullscreen = NA
      )
    }
  })
  output$ctmmRayshader_rglwidget=renderUI({
    if (input$exampleRayshader == "Rayshader Example 1") {
      htmltools::includeHTML("data/auxiliary/local-files/provided-app-files/rglWidget/Example_1.html")
    }else if (input$exampleRayshader == "Rayshader Example 2") {
      htmltools::includeHTML("data/auxiliary/local-files/provided-app-files/rglWidget/Example_2.html")
    }
  })
  
  # output$ctmmRayshader_rglwidget <- renderUI({
  #   req(input$exampleRayshader)
  #   
  #   file <- switch(input$exampleRayshader,
  #                  "Rayshader Example 1" = "rglWidget/Example_1.html",
  #                  "Rayshader Example 2" = "rglWidget/Example_2.html"
  #   )
  #   
  #   tags$iframe(
  #     src = file, width = "100%", height = "600",
  #     frameborder = "0", allowfullscreen = NA
  #   )
  # })
  
  # # Video stuff
  # output$example_video <- renderUI({
  #   if (input$example == "Example 1") {
  #     tags$iframe(
  #       src = "https://www.youtube.com/embed/9cVsvhUwrGc",
  #       width = "1200px",
  #       height = "1080px",
  #       frameborder = "0",
  #       allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
  #       allowfullscreen = NA
  #     )
  #   } 
  #   else if(input$example == "Example 2"){
  #     tags$iframe(
  #       src = "https://www.youtube.com/embed/8uCLJxMKs_c",
  #       width = "1200px",
  #       height = "600px",
  #       frameborder = "0",
  #       allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
  #       allowfullscreen = NA
  #     )
  #     
  #   }
  #   else if(input$example == "Example 3"){
  #     tags$iframe(
  #       src = "https://www.youtube.com/embed/yfEp7f5hOec",
  #       width = "640px",
  #       height = "360px",
  #       frameborder = "0",
  #       allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
  #       allowfullscreen = NA
  #     )
  #     
  #     
  #     
  #   }})
  
  # # Load pre-existing data
  # load("data/auxiliary/local-files/provided-app-files/Cillia21.RData")
  # Example1_data <- read_sf("data/auxiliary/local-files/provided-app-files/test.kml")
  # Example2_data <- read_sf("data/auxiliary/local-files/provided-app-files/test.kml")
  # Example3_data <- read_sf("data/auxiliary/local-files/provided-app-files/test.kml")
  # 
  # # User-uploaded data
  # Data <- reactive({
  #   req(input$file)
  #   read.csv(input$file$datapath, header = TRUE)
  # })
  # 
  # telemetryData <- eventReactive(input$submit, {
  #   req(Data())
  #   as.telemetry(Data())
  # })
  # 
  # Model <- reactive({
  #   req(input$Model_Object)
  #   env <- new.env()
  #   load(input$Model_Object$datapath, envir = env)
  #   obj_names <- ls(env)
  #   validate(need(length(obj_names) == 1, "Uploaded RData file must contain exactly one object."))
  #   get(obj_names[1], envir = env)
  # })
  # 
  # # --- Example Plot Output ---
  # output$pathPlot <- renderPlotly({
  #   if (input$example == "Example as.kml run") {
  #     as.kml(CTMM = list(FIT),
  #            all_tour = FALSE,
  #            simulation_icons = TRUE,
  #            error_circle = TRUE,
  #            duration = 60, 
  #            animals = list(Cillia), 
  #            sequencetime = 5,
  #            pov_cam = FALSE,
  #            follow_cam = TRUE,
  #            num_simulations = 10)
  #     data <- read_sf("test.kml")
  #   } else {
  #     
  #     
  #     line_predict1 <- Example1_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Predict Path", Name))
  #     
  #     line_datasimulation1 <- Example1_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Simulation", Name))
  #     
  #     point_data1 <- Example1_data %>%
  #       filter(st_geometry_type(geometry) == "POINT",
  #              grepl("Animal 1$", Name))
  #     Example1_plot <- ggplot() + 
  #       geom_sf(data = line_predict1, color = "blue", size = 2) +
  #       geom_sf(data = line_datasimulation1, color = "green", size = 1)  +
  #       geom_sf(data = point_data1, color = "red", size = 3) +
  #       theme_minimal() +
  #       labs(title = "Example Animal Path", x = "Longitude", y = "Latitude")
  #     #### EXAMPLE 2 ####
  #     line_predict2 <- Example2_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Predict Path", Name))
  #     
  #     line_datasimulation2 <- Example2_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Simulation", Name))
  #     
  #     point_data2 <- Example2_data %>%
  #       filter(st_geometry_type(geometry) == "POINT",
  #              grepl("Animal 1$", Name))
  #     Example2_plot <- ggplot() + 
  #       geom_sf(data = line_predict2, color = "blue", size = 2) +
  #       # geom_sf(data = line_datasimulation1, color = "green", size = 1)  +
  #       geom_sf(data = point_data2, color = "red", size = 3) +
  #       theme_minimal() +
  #       labs(title = "Example Animal Path", x = "Longitude", y = "Latitude")
  #     #### EXAMPLE 3 ####
  #     
  #     line_predict3 <- Example3_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Predict Path", Name))
  #     
  #     line_datasimulation3 <- Example3_data %>%
  #       filter(st_geometry_type(geometry) == "LINESTRING",
  #              grepl("Simulation", Name))
  #     
  #     point_data3 <- Example3_data %>%
  #       filter(st_geometry_type(geometry) == "POINT",
  #              grepl("Animal 1$", Name))
  #     Example3_plot <- ggplot() + 
  #       geom_sf(data = line_predict3, color = "green", size = 2) +
  #       geom_sf(data = line_datasimulation3, color = "red", size = 1)  +
  #       geom_sf(data = point_data3, color = "black", size = 3) +
  #       theme_minimal() +
  #       labs(title = "Example Animal Path", x = "Longitude", y = "Latitude")
  #     #####
  #     p <- switch(input$example,
  #                 "Example 1" = Example1_plot,
  #                 "Example 2" = Example2_plot,
  #                 "Example 3" = Example3_plot)
  #   }
  #   
  #   # req(data)
  #   # line_data <- data %>% filter(st_geometry_type(geometry) == "LINESTRING")
  #   # point_data <- data %>% filter(st_geometry_type(geometry) == "POINT")
  #   # 
  #   # p <- ggplot() +
  #   #   geom_sf(data = line_data, color = input$Example_SimulationColor, size = 1) +
  #   #   geom_sf(data = point_data, color = "red", size = 3) +
  #   #   theme_minimal() +
  #   #   labs(title = "Example Animal Path", x = "Longitude", y = "Latitude")
  #   
  #   ggplotly(p)
  # })
  # 
  # # --- Uploaded Data Plot Output ---
  # output$uploadPlot <- renderPlotly({
  #   req(telemetryData())
  #   df <- telemetryData()
  #   
  #   FIT <- if (input$plotType == "No") {
  #     GUESS <- ctmm.guess(df, interactive = FALSE)
  #     ctmm.fit(df, GUESS, trace = TRUE)
  #   } else {
  #     Model()
  #   }
  #   
  #   as.kml <- function(DATA,
  #                      CTMM = list(), 
  #                      all_tour = FALSE,
  #                      duration = 180,
  #                      num_simulations = 10,
  #                      animal_icon = TRUE,
  #                      error_circle = FALSE,
  #                      error_ellipses = FALSE,
  #                      simulation_icons= FALSE,
  #                      pov_cam = FALSE,
  #                      manual_cam = FALSE,
  #                      follow_cam = FALSE,
  #                      central_cam = FALSE,
  #                      color_sim = "red",
  #                      iconsize = 1.5, 
  #                      markerimage = "https://pixelartmaker-data-78746291193.nyc3.digitaloceanspaces.com/image/fbc13eca20f56cd.png", 
  #                      color_icon = "blue",
  #                      color_pred = "green",
  #                      sequencetime = 3,
  #                      opacity = 65,
  #                      circlepoints = 15,
  #                      confidence = 2.45,
  #                      path_altitude = 0,
  #                      cam_altitude = 300,
  #                      coords=  list(longitude = "longitude", 
  #                                    latitude = "latitude", 
  #                                    timestamp = "timestamp")) {
  #     
  #     if (is.null(CTMM)) {
  #       print("Please provide model('s)")
  #     }
  #     # To fit the models to the telemetry list and convert individual to a list to allow for proper use in as.kml
  #     if (class(DATA) == "list") {
  #       if (is.list(CTMM) && all(sapply(CTMM, inherits, "ctmm"))) {
  #         ids_from_fit <- sapply(CTMM, function(model) model@info$identity)
  #         
  #         DATA <- DATA[ids_from_fit]
  #       } 
  #     } else if (class(DATA) == "telemetry") {
  #       DATA = list(DATA)
  #     }
  #     animal_data = DATA
  #     number_of_animals <- length(animal_data)
  #     
  #     # Converts a color name and opacity percentage to KML color format
  #     get_kml_color <- function(color_name, opacity_percent) {
  #       rgb_vals <- col2rgb(color_name)
  #       red <- rgb_vals[1]
  #       green <- rgb_vals[2]
  #       blue <- rgb_vals[3]
  #       
  #       red_hex <- sprintf("%02X", red)
  #       green_hex <- sprintf("%02X", green)
  #       blue_hex <- sprintf("%02X", blue)
  #       
  #       alpha <- round((opacity_percent / 100) * 255)
  #       alpha_hex <- sprintf("%02X", alpha)
  #       
  #       paste0(alpha_hex, blue_hex, green_hex, red_hex)
  #     }
  #     
  #     create_path_kml <- function(coords, altitude, name, color_name, opacity_percent) {
  #       path_coords <- paste(coords[, 1], coords[, 2], altitude, sep = ",", collapse = " ")
  #       kml_color <- get_kml_color(color_name, opacity_percent)
  #       
  #       sprintf('
  # <Placemark>
  #   <name>%s</name>
  #   <Style>
  #     <LineStyle>
  #       <color>%s</color>
  #       <width>2</width>
  #     </LineStyle>
  #   </Style>
  #   <LineString>
  #     <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
  #     <coordinates>
  #       %s
  #     </coordinates>
  #   </LineString>
  # </Placemark>\n', 
  #               name, kml_color, path_coords
  #       )
  #     }
  #     
  #     
  #     create_icon_kml <- function(lon, lat, name, color_name, opacity_percent,
  #                                 markerimage, iconsize, iconorder = 1) {
  #       coord_str <- paste(lon[1], lat[1], sep = ",")
  #       kml_color <- get_kml_color(color_name, opacity_percent)
  #       
  #       sprintf('
  # <Placemark id = "%s">
  #   <name>%s</name>
  #   <Style>
  #     <IconStyle>
  #       <color>%s</color>
  #       <scale>%.1f</scale>
  #       <zIndex>%f</zIndex>
  #       <Icon>
  #         <href>%s</href>
  #       </Icon>
  #     </IconStyle>
  #   </Style>
  #   <Point>
  #     <coordinates>%s,0</coordinates>
  #   </Point>
  # </Placemark>', 
  #               name, name,
  #               kml_color,
  #               iconsize,
  #               iconorder,
  #               markerimage,
  #               coord_str)
  #     }
  #     
  #     
  #     generate_kml_for_animals <- function(animal_data) {
  #       kml_content <- ''
  #       all_predictions <- list()
  #       
  #       results <- data.frame(time = numeric(), i = numeric(), stringsAsFactors = FALSE)
  #       all_animals <- data.frame(time = numeric(), i = numeric(), stringsAsFactors = FALSE)
  #       all_circle <- data.frame(time = numeric(), i = numeric(), stringsAsFactors = FALSE)
  #       all_ellipsoid <- data.frame(time = numeric(), i = numeric(), stringsAsFactors = FALSE)
  #       
  #       animal_names <- unlist(DATA)
  #       for (i in seq_along(animal_data)) {
  #         # this is here due to me making the data not a list anymore, but that breaks the code
  #         # Variables made for each animal each loop.
  #         
  #         animal <- animal_data[[i]]
  #         CTMM_Model <- CTMM[[i]]
  #         lon <- animal[[coords$longitude]]
  #         lat <- animal[[coords$latitude]]
  #         if (!is.null(CTMM)) {
  #           
  #           
  #           SEQ <- seq(from = animal$t[1], to = animal$t[nrow(animal)], by = sequencetime %#% 'min')
  #           
  #           simulations <- list()
  #           for (sim in 1:num_simulations) {
  #             simulations[[sim]] <- simulate(data = animal, CTMM_Model, t = SEQ, complete = TRUE)
  #           }
  #           
  #           PRED <- predict(CTMM_Model, data = animal, t = SEQ, complete = TRUE)
  #           
  #           # Calculate the duration of each animation in seconds
  #           
  #           rowcount <- nrow(PRED)
  #           
  #           calculated_duration <- duration /rowcount
  #           
  #           
  #           processing <- data.frame(
  #             t = PRED$t,
  #             longitude = PRED$longitude,
  #             latitude = PRED$latitude,
  #             COV_x_x = PRED$COV.x.x,
  #             COV_y_y = PRED$COV.y.y,
  #             COV_x_y = PRED$COV.x.y
  #           )
  #           # project function taken from ctmm
  #           
  #           project <- function(x, from = DATUM, to = DATUM) 
  #           {
  #             if (to == from) {
  #               return(x)
  #             }
  #             x <- data.frame(x)
  #             from <- sf::st_crs(from)
  #             to <- sf::st_crs(to)
  #             x <- sf::st_as_sf(x, coords = 1:2, crs = from)
  #             x <- sf::st_transform(x, crs = to)
  #             x <- sf::st_coordinates(x)
  #             colnames(x) <- c("x", "y")
  #             return(x)
  #           }
  #           # this function is what makes the circle coordinates, confidence and circlepoints can be changed by user.
  #           generate_circle_coord <- function(longitude, latitude, radius, num_points = circlepoints, confidencevalue = confidence, crs_proj = NULL) {
  #             crs_proj <- crs_proj %||% "+proj=utm +zone=33 +datum=WGS84"
  #             
  #             center_coords <- project(data.frame(x = longitude, y = latitude), from = 4326, to = crs_proj)
  #             
  #             angles <- seq(0, 2 * pi, length.out = num_points)
  #             circle_cartesian <- data.frame(
  #               x = center_coords[1] + (radius * cos(angles))* confidencevalue,
  #               y = center_coords[2] + (radius * sin(angles))* confidencevalue
  #             )
  #             circle_longlat <- project(circle_cartesian, from = crs_proj, to = 4326)
  #             
  #             as.data.frame(circle_longlat) %>%
  #               setNames(c("circle_longitude", "circle_latitude"))
  #           }
  #           
  #           generate_ellipse_coord <- function(longitude, latitude, sigma, level = 0.95, crs_proj = NULL) {
  #             crs_proj <- crs_proj %||% "+proj=utm +zone=33 +datum=WGS84"
  #             
  #             center_coords <- project(data.frame(x = longitude, y = latitude), from = 4326, to = crs_proj)
  #             
  #             mu <- as.numeric(center_coords[1, ])
  #             sigma <- sigma
  #             ellipse_proj <- ellipsograph(mu, sigma, level = 0.95, PLOT = FALSE)
  #             
  #             ellipse_longlat <- project(ellipse_proj, from = crs_proj, to = 4326)
  #             as.data.frame(ellipse_longlat) %>%
  #               setNames(c("ellipse_longitude", "ellipse_latitude"))
  #           }
  #           
  #           
  #           
  #           # add raduis into each column and then use the circle coord function to 
  #           # generate the long lat for each circle point  
  #           
  #           ################################            
  #           if(error_circle == TRUE){
  #             processing <- processing %>%
  #               rowwise() %>%
  #               mutate(
  #                 radius = sqrt((COV_x_x + COV_y_y) / 2),
  #                 circle_coords = list(generate_circle_coord(longitude, latitude, radius))
  #               ) %>%
  #               ungroup()
  #           }
  #           #########################
  #           #########################################  ERROR ellipsoid   FROM CTMM? #####################
  #           clamp <- function(x, lower, upper) {
  #             pmax(lower, pmin(x, upper))
  #           }
  #           
  #           ellipsograph <- function(mu, sigma, level=0.95, fg="black", bg=NA, PLOT=FALSE,num_points = circlepoints, ...) {
  #             Eigen <- eigen(sigma)
  #             std <- Eigen$values
  #             std[1] <- clamp(std[1], 0, Inf)
  #             std[2] <- clamp(std[2], 0, std[1])
  #             std <- sqrt(std)
  #             vec <- Eigen$vectors
  #             
  #             alpha <- 1 - level
  #             z <- sqrt(-2*log(alpha))  # confidence scale
  #             
  #             num <- circlepoints
  #             theta <- 2*pi*(0:num)/(num+1)
  #             Sin <- sin(theta)
  #             Cos <- cos(theta)
  #             
  #             x <- mu[1] + z*(Cos*std[1]*vec[1,1] + Sin*std[2]*vec[1,2])
  #             y <- mu[2] + z*(Cos*std[1]*vec[2,1] + Sin*std[2]*vec[2,2])
  #             
  #             if (PLOT) {
  #               plot(x, y, type = "l", asp = 1, col = fg, ...)
  #               points(mu[1], mu[2], pch = 19, col = "red") # Mark center
  #             } else {
  #               return(cbind(x = x, y = y))
  #             }
  #           }
  #           #########################################
  #           
  #           if (error_ellipses == TRUE) {
  #             processing <- processing %>%
  #               rowwise() %>%
  #               mutate(
  #                 sigma = list(matrix(c(COV_x_x, COV_x_y, COV_x_y, COV_y_y), nrow = 2, byrow = TRUE)),
  #                 ellipses_coords = list(generate_ellipse_coord(
  #                   longitude, latitude,
  #                   sigma = sigma,
  #                   level = confidence,
  #                 ))
  #               ) %>%
  #               ungroup()
  #             
  #           }
  #           predict_path <- cbind(PRED$longitude, PRED$latitude)
  #           
  #           initial_coords <- predict_path[[1]]
  #           
  #           
  #           all_predictions[[i]] <- PRED           #stores the predictions to be used in the All Tour section
  #           
  #           # creates any number of simulations the user wants, with color being set by the user.
  #           for (sim in 1:num_simulations) {
  #             lon <- simulations[[sim]]$longitude
  #             lat <- simulations[[sim]]$latitude
  #             sim_coords <- cbind(simulations[[sim]]$longitude, simulations[[sim]]$latitude)
  #             kml_content <- paste0(kml_content, create_path_kml(sim_coords, path_altitude, name = paste("Animal", i, "Simulation", sim), color_sim, opacity))
  #             kml_content <- paste0(kml_content, create_icon_kml(lon,lat, name = paste("Simulation", sim, i), color_sim, opacity,markerimage,iconsize))
  #           }
  #           animalname <- animal_names[i] 
  #           
  #           icon <- as.character(markerimage)
  #           # creates the main predicted path
  #           kml_content <- paste0(kml_content, create_path_kml(predict_path, path_altitude, name = paste("Animal", i, "Predict Path"), color_pred,opacity))
  #           
  #           kml_content <-paste0(kml_content, create_icon_kml(PRED$longitude,PRED$latitude, name = paste("Animal", i), color_icon,opacity, icon,iconsize,iconorder=2))
  #           
  #           # initial position for each animal marker
  #           
  #           kml_content <- paste0(kml_content, sprintf( '
  # <Placemark id="moving_circle_%s">
  #  <name> Moving Animal Circle %s </name>
  #   <Polygon>
  #   <Style>
  #     <PolyStyle>
  #       <color>A30000ff</color> 
  #     </PolyStyle>
  #   </Style>
  #     <outerBoundaryIs>
  #       <LinearRing>
  #         <coordinates>%s</coordinates>
  #       </LinearRing>
  #     </outerBoundaryIs>
  #   </Polygon>
  # </Placemark>
  # ', i, i, initial_coords))
  #           kml_content <- paste0(kml_content, sprintf( '
  # <Placemark id="moving_ellipsoid_%s">
  #  <name> Moving Animal Ellipsoid %s </name>
  #   <Polygon>
  #   <Style>
  #     <PolyStyle>
  #       <color>A30000ff</color> 
  #     </PolyStyle>
  #   </Style>
  #     <outerBoundaryIs>
  #       <LinearRing>
  #         <coordinates>%s</coordinates>
  #       </LinearRing>
  #     </outerBoundaryIs>
  #   </Polygon>
  # </Placemark>
  # ', i, i, initial_coords))
  #           
  #           #####
  #           # tour content for each animal (animation portion) # 
  #           
  #           
  #           kml_content <- paste0(kml_content, sprintf('
  # <gx:Tour>
  #   <name>Animal %s Animated Path</name>
  #   <gx:Playlist>
  # ', animalname))
  #           
  #           num_timesteps <- nrow(PRED)
  #           
  #           all_change_content <- vector("list", num_timesteps)
  #           all_camera_content <- vector ("list", num_timesteps)
  #           if (simulation_icons == TRUE) { 
  #             num_timesteps <- nrow(simulations[[1]])
  #             
  #             
  #             
  #             for (b in 1:num_timesteps) {
  #               
  #               current_row <- data.frame(time = simulations[[1]]$t[b], i = i, stringsAsFactors = FALSE)
  #               
  #               for (sim in 1:length(simulations)) {
  #                 current_sim <- simulations[[sim]]  
  #                 
  #                 # Get the longitude and latitude for the current timestep
  #                 lon <- current_sim$longitude[b]
  #                 lat <- current_sim$latitude[b]
  #                 
  #                 # Create a new column for the current simulation
  #                 current_row[[paste0("Simulation_", sim)]] <- paste(lon,",",lat)
  #               }
  #               results <- rbind(results, current_row)
  #               
  #               for (sim in 1:length(simulations)) {
  #                 current_sim <- simulations[[sim]]  
  #                 
  #                 lon <- current_sim$longitude[b]
  #                 lat <- current_sim$latitude[b]
  #                 
  #                 change_section <- sprintf('
  #     <Placemark targetId="Simulation %d %d">
  #       <Point>
  #         <coordinates>%f,%f,0</coordinates>
  #       </Point>
  #     </Placemark>',
  #                                           sim, i, lon, lat)
  #                 
  #                 # Add to the existing content in this row
  #                 all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #               }
  #             }
  #           }
  #           if (animal_icon == TRUE) { 
  #             num_timesteps <- nrow(PRED)
  #             #animal_icon_ids[[i]] <- paste0(sprintf('"Animal %d"', animalname))
  #             
  #             for (b in 1:num_timesteps) {
  #               current_row <- data.frame(
  #                 time = PRED$t[b],  # Access time column in PRED
  #                 i = i, 
  #                 stringsAsFactors = FALSE
  #               )
  #               
  #               lon <- PRED$longitude[b]
  #               lat <- PRED$latitude[b]
  #               
  #               # Add the animal coordinates column
  #               current_row[[paste0("Animal")]] <- paste(lon, ",", lat)
  #               
  #               all_animals <- rbind(all_animals, current_row)
  #               change_section <- sprintf('
  #     <Placemark targetId="Animal %d">
  #       <Point>
  #         <coordinates>%f,%f,0</coordinates>
  #       </Point>
  #     </Placemark>',
  #                                         i, lon, lat)
  #               
  #               all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #             }
  #           }
  #           if (error_circle == TRUE) { 
  #             num_timesteps <- nrow(processing)
  #             #circle_ids[[i]] <- paste0(sprintf('"moving_circle_%d"', animalname))
  #             
  #             for (b in 1:num_timesteps) {
  #               coords_str <- paste(
  #                 apply(processing$circle_coords[[b]], 1, function(row) paste(row, collapse = ",")), 
  #                 collapse = " "
  #               )     
  #               current_row <- data.frame(
  #                 time = PRED$t[b],  # Access time column in PRED
  #                 i = i, 
  #                 stringsAsFactors = FALSE
  #               )
  #               
  #               
  #               
  #               current_row[[paste0("Circle")]] <- paste(coords_str)
  #               
  #               all_circle <- rbind(all_circle, current_row)
  #               
  #               change_section <- sprintf('
  #           <Placemark targetId="moving_circle_%s">
  #             <Polygon>
  #               <outerBoundaryIs>
  #                 <LinearRing>
  #                   <coordinates>%s</coordinates>
  #                 </LinearRing>
  #               </outerBoundaryIs>
  #             </Polygon>
  #           </Placemark>',
  #                                         i, coords_str)
  #               
  #               all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #             }
  #           }
  #           if (error_ellipses == TRUE) { 
  #             num_timesteps <- nrow(processing)
  #             
  #             for (b in 1:num_timesteps) {
  #               coords_str <- paste(
  #                 apply(processing$ellipses_coords[[b]], 1, function(row) paste(row, collapse = ",")), 
  #                 collapse = " "
  #               )     
  #               current_row <- data.frame(
  #                 time = PRED$t[b],  # Access time column in PRED
  #                 i = i, 
  #                 stringsAsFactors = FALSE
  #               )
  #               
  #               
  #               
  #               current_row[[paste0("Ellipsoid")]] <- paste(coords_str)
  #               
  #               all_ellipsoid <- rbind(all_ellipsoid, current_row)
  #               
  #               change_section <- sprintf('
  #           <Placemark targetId="moving_ellipsoid_%s">
  #             <Polygon>
  #               <outerBoundaryIs>
  #                 <LinearRing>
  #                   <coordinates>%s</coordinates>
  #                 </LinearRing>
  #               </outerBoundaryIs>
  #             </Polygon>
  #           </Placemark>',
  #                                         i, coords_str)
  #               
  #               all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #             }
  #           }
  #           if (pov_cam == TRUE){ 
  #             num_timesteps <- nrow(processing)
  #             
  #             for (b in 1:num_timesteps) {
  #               lon1 <- PRED$longitude[b]
  #               lat1 <- PRED$latitude[b]
  #               lon2 <- PRED$longitude[b+1]
  #               lat2 <- PRED$latitude[b+1]
  #               
  #               current_row <- data.frame(
  #                 time = PRED$t[b],  # Access time column in PRED
  #                 i = i, 
  #                 stringsAsFactors = FALSE
  #               )
  #               
  #               
  #               
  #               
  #               azimuth <- bearing(c(lon1, lat1), c(lon2, lat2))
  #               
  #               range <- distHaversine(c(lon1, lat1), c(lon2, lat2))
  #               
  #               change_section <- sprintf('
  #             
  #       <gx:duration>%f</gx:duration>
  #       <gx:flyToMode>smooth</gx:flyToMode>
  #       <LookAt>
  #         <longitude>%f</longitude>
  #         <latitude>%f</latitude>
  #         <altitude>10</altitude>
  #         <heading>%f</heading>
  #         <tilt>90</tilt>
  #         <range>%f</range>
  #         <gx:altitudeMode>relativeToGround</gx:altitudeMode>
  #       </LookAt>
  #     ',
  #                                         calculated_duration, lon2, lat2, azimuth,range)
  #               
  #               all_camera_content[[b]] <- paste0(all_camera_content[[b]], change_section)
  #             }
  #           }
  #           if (follow_cam == TRUE){          num_timesteps <- nrow(processing)
  #           
  #           for (b in 1:num_timesteps) {
  #             lon <- PRED$longitude[b]
  #             lat <- PRED$latitude[b]
  #             
  #             current_row <- data.frame(
  #               time = PRED$t[b],  # Access time column in PRED
  #               i = i, 
  #               stringsAsFactors = FALSE
  #             )
  #             
  #             change_section <- sprintf('
  #             
  #       <gx:duration>%f</gx:duration>
  #       <gx:flyToMode>smooth</gx:flyToMode>
  #       <LookAt>
  #         <longitude>%f</longitude>
  #         <latitude>%f</latitude>
  #         <altitude>%f</altitude>
  #         <tilt>0</tilt>
  #         <gx:altitudeMode>relativeToGround</gx:altitudeMode>
  #       </LookAt>
  #     ',
  #                                       calculated_duration, lon, lat, cam_altitude)
  #             
  #             all_camera_content[[b]] <- paste0(all_camera_content[[b]], change_section)
  #             
  #           }
  #           
  #           }
  #           if (manual_cam == TRUE){ 
  #             num_timesteps <- nrow(processing)
  #             
  #             for (b in 1:num_timesteps) {
  #               lon1 <- PRED$longitude[b]
  #               lat1 <- PRED$latitude[b]
  #               lon2 <- PRED$longitude[b+1]
  #               lat2 <- PRED$latitude[b+1]
  #               
  #               current_row <- data.frame(
  #                 time = PRED$t[b],  # Access time column in PRED
  #                 i = i, 
  #                 stringsAsFactors = FALSE
  #               )
  #               
  #               
  #               
  #               
  #               azimuth <- bearing(c(lon1, lat1), c(lon2, lat2))
  #               
  #               range <- distHaversine(c(lon1, lat1), c(lon2, lat2))
  #               
  #               change_section <- sprintf('
  #             
  #       <gx:duration>%f</gx:duration>
  #     ',
  #                                         calculated_duration)
  #               
  #               all_camera_content[[b]] <- paste0(all_camera_content[[b]], change_section)
  #             }
  #           }
  #           
  #           for (b in 1:nrow(predict_path)) {
  #             
  #             
  #             kml_content <- paste0(kml_content, sprintf('
  #     <gx:AnimatedUpdate>
  #       <gx:duration>%f</gx:duration>
  #       <Update>
  #         <Change>
  #             %s
  #         </Change>
  #       </Update>
  #     </gx:AnimatedUpdate>
  # 
  #     <gx:FlyTo>
  #       %s
  #     </gx:FlyTo>
  #     ', calculated_duration, all_change_content[[b]], all_camera_content[[b]]))
  #             
  #             # monitor message for each animated update
  #             message(sprintf("Animating position %d for Animal %d", b, i))
  #           }
  #           
  #           # close the tour section after all animals have had their tour generated
  #           
  #           kml_content <- paste0(kml_content, '
  #   </gx:Playlist>
  # </gx:Tour>
  # ')
  #           
  #           
  #           
  #           
  #         }
  #         
  #       } 
  #       
  #       if (all_tour) {
  #         combined_predictions <- cbind(all_animals, all_circle, results)
  #         #####
  #         
  #         long_lat_df <- combined_predictions %>%
  #           select(matches("Animal|Simulation_")) %>%  # Select only columns with coordinates
  #           pivot_longer(everything(), names_to = "Type", values_to = "Coordinates") %>%
  #           separate(Coordinates, into = c("Longitude", "Latitude"), sep = ",", convert = TRUE)
  #         # Calculate the bounding box
  #         min_lon<- min(long_lat_df$Longitude)
  #         max_lon<- max(long_lat_df$Longitude)
  #         min_lat<- min(long_lat_df$Latitude)
  #         max_lat<- max(long_lat_df$Latitude)
  #         
  #         
  #         mid_lat <- (min_lat+ max_lat) / 2
  #         
  #         mid_lon <- (min_lon + max_lon) / 2
  #         
  #         top_left <- c(min_lon, max_lat)
  #         
  #         bottom_right <- c(max_lon, min_lat)
  #         
  #         max_distance <- distVincentyEllipsoid(top_left, bottom_right)
  #         
  #         altitude <- max_distance * 2
  #         
  #         #####
  #         processing <- data.frame(
  #           t = combined_predictions$t,
  #           longitude = combined_predictions$longitude,
  #           latitude = combined_predictions$latitude,
  #           COV_x_x = combined_predictions$COV.x.x,
  #           COV_y_y = combined_predictions$COV.y.y,
  #           animalid = combined_predictions$animalid
  #         )
  #         
  #         rowcount <- nrow(combined_predictions)
  #         
  #         calculated_duration <- duration /rowcount
  #         
  #         # The tour animation for each animal
  #         
  #         
  #         kml_content <- paste0(kml_content, sprintf('
  # <gx:Tour>
  #   <name>Animal %s Animated Path</name>
  #   <gx:Playlist>
  # ', animalname))
  #         num_timesteps <- nrow(results)
  #         num_column <- ncol(results) - 2
  #         all_change_content <- vector("list", num_timesteps)
  #         all_camera_content <- vector ("list", num_timesteps)
  #         
  #         if (simulation_icons == TRUE) { 
  #           
  #           for (b in 1:num_timesteps) {
  #             
  #             
  #             # Add simulation icons content for this timestep
  #             for (sim in 1:num_column) {
  #               column_name <- paste0("Simulation_", sim)
  #               i <- results$i
  #               current_sim <- results[[column_name]]  # Access current simulation
  #               icon_coords <- current_sim[b]
  #               
  #               
  #               change_section <- sprintf('
  #     <Placemark targetId="Simulation %d %d">
  #       <Point>
  #         <coordinates>%s,0</coordinates>
  #       </Point>
  #     </Placemark>',
  #                                         sim, i[b], icon_coords)
  #               # Add to the existing content in this row
  #               all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #             }
  #           }
  #         }
  #         if (animal_icon == TRUE) {
  #           
  #           
  #           
  #           for (b in 1:num_timesteps) {
  #             
  #             
  #             # Add animal icons content for this timestep
  #             i <- all_animals$i[b]
  #             animal_coord <- all_animals$Animal[b]
  #             
  #             change_section <- sprintf('
  #     <Placemark targetId="Animal %d">
  #       <Point>
  #         <coordinates>%s,0</coordinates>
  #       </Point>
  #     </Placemark>',
  #                                       i, animal_coord)
  #             
  #             # Add to the existing content in this row
  #             all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #             
  #           }
  #         }
  #         if (error_circle == TRUE) { 
  #           num_timesteps <- nrow(all_animals)
  #           
  #           for (b in 1:num_timesteps) {
  #             i <- all_circle$i[b]
  #             coords_str <- all_circle$Circle[b] 
  #             change_section <- sprintf('
  #           <Placemark targetId="moving_circle_%s">
  #             <Polygon>
  #               <outerBoundaryIs>
  #                 <LinearRing>
  #                   <coordinates>%s</coordinates>
  #                 </LinearRing>
  #               </outerBoundaryIs>
  #             </Polygon>
  #           </Placemark>',
  #                                       i, coords_str)
  #             
  #             # Add to the existing content in this row
  #             all_change_content[[b]] <- paste0(all_change_content[[b]], change_section)
  #           }
  #         }
  #         if (central_cam == TRUE){         
  #           num_timesteps <- nrow(all_animals)
  #           
  #           
  #           for (b in 1:num_timesteps) {
  #             
  #             animal_coord <- all_animals$Animal[b]
  #             
  #             current_row <- data.frame(
  #               time = all_animals$t[b],  # Access time column in all_animals
  #               i = i, 
  #               stringsAsFactors = FALSE
  #             )
  #             
  #             change_section <- sprintf('
  #             
  #       <gx:duration>%f</gx:duration>
  #       <gx:flyToMode>smooth</gx:flyToMode>
  #       <LookAt>
  #         <longitude>%f</longitude>
  #         <latitude>%f</latitude>          
  #         <altitude>%f</altitude>
  #         <tilt>0</tilt>
  #         <gx:altitudeMode>relativeToGround</gx:altitudeMode>
  #       </LookAt>
  #     ',
  #                                       calculated_duration, mid_lon, mid_lat, altitude)
  #             
  #             all_camera_content[[b]] <- paste0(all_camera_content[[b]], change_section)
  #             
  #           }
  #           
  #         }
  #         if (manual_cam == TRUE){ 
  #           num_timesteps <- nrow(all_animals)
  #           
  #           for (b in 1:num_timesteps) {
  #             
  #             
  #             change_section <- sprintf('
  #             
  #       <gx:duration>%f</gx:duration>
  #     ',
  #                                       calculated_duration)
  #             
  #             all_camera_content[[b]] <- paste0(all_camera_content[[b]], change_section)
  #           }
  #         }
  #         
  #         for (b in 1:nrow(combined_predictions)) {
  #           
  #           
  #           kml_content <- paste0(kml_content, sprintf('
  #     <gx:AnimatedUpdate>
  #       <gx:duration>%f</gx:duration>
  #       <Update>
  #         <Change>
  #             %s
  #         </Change>
  #       </Update>
  #     </gx:AnimatedUpdate>
  # 
  #     <gx:FlyTo>
  #      %s
  #     </gx:FlyTo>
  #     ', calculated_duration, all_change_content[[b]], all_camera_content[[b]]))
  #           
  #           # monitor message for each animated update
  #           message(sprintf("Animating position %d for Moving Circle Polygon %s", b, animalname))
  #         }
  #         kml_content <- paste0(kml_content, '
  #   </gx:Playlist>
  # </gx:Tour>
  # ')
  #         
  #         
  #         
  #         
  #       }
  #       
  #       
  #       return(kml_content)
  #     }
  #     
  #     if (length(DATA) > 0) {
  #       kml_content <- generate_kml_for_animals(DATA)
  #     } else {
  #       kml_content <- generate_kml_for_animals(list(data))
  #     }
  #     
  #     kml_header <- '<?xml version="1.0" encoding="UTF-8"?>
  # <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  # <Document>
  # <name>Animal Simulation Paths</name>'
  #     
  #     kml_footer <- '</Document>
  # </kml>'
  #     
  #     kml_output <- paste0(kml_header, kml_content, kml_footer)
  #     writeLines(kml_output, "data/auxiliary/local-files/provided-app-files/test.kml")
  #   }
  #   
  #   
  #   as.kml(
  #     CTMM = list(FIT),
  #     all_tour = FALSE,
  #     error_circle = input$ErrorCircle == "TRUE",
  #     color_sim = input$SimulationColor_upload,
  #     color_pred = input$PredictColor,
  #     duration = input$Duration,
  #     sequencetime = input$sequencetime,
  #     DATA = df,
  #     animal_icon = input$AnimalIcon == "TRUE",
  #     simulation_icons = input$SimulationIcon == "TRUE",
  #     pov_cam = input$POVCam == "TRUE",
  #     follow_cam = input$FollowCam == "TRUE",
  #     num_simulations = input$SimulationNumber
  #   )
  #   
  #   kml_data <- read_sf("data/auxiliary/local-files/provided-app-files/test.kml")
  #   line_data <- kml_data %>% filter(st_geometry_type(geometry) == "LINESTRING")
  #   point_data <- kml_data %>% filter(st_geometry_type(geometry) == "POINT")
  #   
  #   p <- ggplot() +
  #     geom_sf(data = line_data, color = input$SimulationColor_upload, size = 1) +
  #     geom_sf(data = point_data, color = "red", size = 3) +
  #     theme_minimal() +
  #     labs(title = "Uploaded Data Path", x = "Longitude", y = "Latitude")
  #   
  #   ggplotly(p)
  #   
  #   
  # })
  # output$downloadKMLExample <- downloadHandler(
  #   filename = function() {
  #     paste0(input$example, ".kml")  
  #   },
  #   content = function(file) {
  #     kml_file <- switch(input$example,
  #                        "Example 1" = "example1.kml",
  #                        "Example 2" = "example2.kml",
  #                        "Example 3" = "example3.kml")
  #     file.copy(kml_file, file)
  #   }
  # )
  # 
  # output$downloadKML <- downloadHandler(                   
  #   filename = function() {
  #     "trajectory.kml"
  #   },
  #   content = function(file) {
  #     file.copy("data/auxiliary/local-files/provided-app-files/test.kml", file)
  #   }
  #)
  
  # data must be returned. Either the unmodified input data, or the modified data by the app

  return(reactive({ current() }))
}
