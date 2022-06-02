library(shiny)
library(shinyWidgets)
library(myvariant)
library(BiocManager)
options(repos = BiocManager::repositories())
library(biomaRt)
library(knitr)
library(dplyr)

# Load the R files with the functions and the required files
source("files.R")
source("classification.R")


ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "superhero"),
  titlePanel(title=div("VaRpp, Semi-Automatic Variant Classification",img(src = "logo-uocs.png"), align="center")),
  sidebarLayout(
    sidebarPanel(width=5,
                 tabsetPanel(
                   
                   # Tab for the variant ID and the manuals inputs
                   tabPanel("Variant classification",
                            textInput("variant", strong("HGVS id or rsID"),"chr1:g.100380997del"),
                          
                            selectInput("PS2", div(HTML("PS2 - If the variant is de novo (parental samples test negative):")),
                                        c("None selected","Paternity confirmed", "Paternity non confirmed"),selected="None selected"),
                            
                            selectInput("PM3", div(HTML("PM3 - For recessive disorders, detected in trans with a pathogenic variant:")),
                                        c("Yes", "No"), selected = c("No")),
                            selectInput("PM6", "PM6 - Assumed de novo, but without confirmation of paternity o maternity:",
                                        c("Yes", "No"), selected = c("No")),
                            selectInput("BS4", "BS4 - Lack of segregation in affected members of a family:",
                                        c("Yes", "No"), selected = c("No")),
                            selectInput("BP2", div(HTML("BP2 - Observed in trans with a pathogenic variant for a fully penetrant dominant disorder; 
                                                  or observed in cis with a pathogenic variant in any inheritance pattern")),
                                        c("Yes", "No"), selected = c("No")),
                            selectInput("PP1", "PP1 - Segregation analysis:",
                                        c("None selected","Co-segregation with disease in multiple affected family members", 
                                          "Lack of segregation in affected members of a family"),selected="None selected"),
                            selectInput("PP4","PP4 - Patient’s phenotype or family history is highly specific for a disease with a single genetic etiology:",
                                        c("Yes", "No"), selected = c("No")),
                            selectInput("BP5","BP5 - Variant found in a case with an alternate molecular basis for disease:",
                                        c("Yes", "No"), selected = c("No")),
                            
                            actionButton("button1","Submit"),
                            actionButton("reset","Reset")),
                  )),
    
    # The main panel will show the  calculated criteria and the final classification
    mainPanel(
      id = "mainpanel", width=7,
      fluidRow(
        uiOutput("manual")),
      fluidRow(dataTableOutput("data"))))
)


server <- function(input, output, session) {
  
  # Apply the function to calculate the criteria for the variant 
  df<-eventReactive(input$button1,{
    validate(need(input$variant != "", "Please enter an ID"))
    first.table(input$variant,input$PS2,input$PM3,
                input$PM6,input$BP2,input$BS4,input$PP1,input$PP4,input$BP5)
  })  
  
  # Render a UI with the caculated criteria and gives the option to change it
  observeEvent(input$button1,
               output$manual<-renderUI({
                 fluidRow(column(1),column(3,
                                           checkboxGroupInput("patho", "Evidence of pathogenicity", group.pat, selected=check.pat(df())),
                                           actionButton("button2","Submit")),
                          column(3,checkboxGroupInput("benign", "Evidence of benign impact", group.ben, selected=check.ben(df()))))
               }))
  
  # Generate the final table with the classification and other data
  observeEvent(input$button2,{
    tab.final<-classification.func(df(),check.pat(df()),check.ben(df()),input$patho,input$benign)
    output$data<-renderDataTable({
      if( isTRUE(is.null(input$patho) && is.null(input$benign))){
        validate("Please select a criteria")
      }
      tab.final},escape=F)})
  
  
  # Reset all the values and data
  observeEvent(input$reset, {
    output$manual<-renderUI(NULL)
    output$data<-renderDataTable(NULL)
    updateTextInput(session, "variant", value = "")
    updateSelectInput(session, "PS2", selected="None selected")
    updateSelectInput(session, "PM3", selected="No")
    updateSelectInput(session, "PM6", selected="No")
    updateSelectInput(session, "BP2", selected="No")
    updateSelectInput(session, "BS4", selected="No")
    updateSelectInput(session, "PP1", selected="None selected")
    updateSelectInput(session, "PP4", selected="No")
    updateSelectInput(session, "BP5", selected="No")
   
  })
}

#Run the application 
shinyApp(ui = ui, server = server)
