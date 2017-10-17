shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    x <- faithful[, 2] # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = 10)
    hist(x, breaks = bins, col = 'blue', border = 'white')
  })
})