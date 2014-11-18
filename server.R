library(shiny)
library(ggplot2)
library(reshape2)

shinyServer(function(input, output) {
  #Handle the file upload
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
#    read.csv(infile$datapath)
    read.table(infile$datapath
      ,header=FALSE
      ,sep=","
      ,col.names=c("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20")
      ,fill=TRUE)
  })

  #Plot the data on a map...
  output$pCPUALL<-renderPlot({
    if (input$getperf == 0) return(NULL)
    fd<-filedata()
    TimeTable<-subset(fd[,c("V1","V2","V3","V4")], fd["V1"]=="ZZZZ")
    nTimeTable<-c("snapCode","snapNum","snapTime","snapDate")
    names(TimeTable)<-nTimeTable

    tCPUALL<-subset(fd[,c("V1","V2","V3","V4","V5","V6","V7","V8")], fd["V1"]=="CPU_ALL")
    nCPU<-c("typeCPU","snapNum","UserPerc","SysPerc","WaitPerc","IdlePerc","Busy","CPUs")
    names(tCPUALL)<-nCPU
    CPUALL<-merge(TimeTable,tCPUALL)
    CPUALL.melt<-melt(data=CPUALL, id.vars="snapNum", measure.vars=c("UserPerc","SysPerc","WaitPerc"))

    #Plot the data on a graph
    ggplot(CPUALL.melt) + geom_line(mapping=aes(x=snapNum, y=value, group=variable, color=variable), position="stack")  + geom_ribbon(mapping=aes(x=snapNum,  y=value, ymin=0, ymax=value, group=variable, fill=variable), position="stack", alpha=.7)
  })
})
