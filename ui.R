library(shiny)

shinyUI(

pageWithSidebar(
  headerPanel("Nmon Analyser"),

  sidebarPanel(
    #Provide a dialogue to upload a file
#    fileInput('datafile', 'Choose CSV file',
#              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    fileInput('datafile', 'Choose .NMON file', accept=c('text/nmon', 'text/comma-separated-values,text/plain')),

    #We don't want the geocoder firing until we're ready...
    actionButton("getperf", "Analyse")

  ),
  mainPanel(
    plotOutput("pCPUALL")
  )
))
