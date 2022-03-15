## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  fig.width=5, fig.height=3,
  collapse = TRUE,
  comment = "#>"
)

## ---- fig.show='hold'---------------------------------------------------------
library(RMagnolia)
library(dplyr)
library(ggplot2)

code = "model VanderPol
derivative        

    cinterval cint = 0.01

    constant xic = -2.0, xdic = 4.0

    constant mu = 2.0
    xdd = mu*(1 - x^2)*xd - x
 
    xd  = integ(xdd, xdic)
    x   = integ(xd, xic)

    constant tstop = 10.0        
    termt(t >= tstop, 'Stopped on time limit')    

end ! derivative    
end ! model"

# Build the model
mdl <- magnoliaBuild(code)

# Indicate which model outputs will be logged
mdl$prepare("t")
mdl$prepare("x")
mdl$prepare("xd")

# Adjust the stopping time to 20.0
mdl$tstop <- 20

# Run the model
mdl$run()

# Get time histories of variables we want to plot and load into a data frame
df <- data.frame(
  T  = mdl$history("t"),
  X  = mdl$history("x"),
  XD = mdl$history("xd")
)

# Plot the trajectories
ggplot(data = df) +
  geom_line(aes(x = T, y = X, color = "X"), size = 1) +
  geom_line(aes(x = T, y = XD, color = "XD"), size = 1) +
  labs(title = "Van der Pol Oscillator", x = "Time", y = "X and dX/dt") +
  theme_bw() +
  theme(legend.title = element_blank())

# Alternativly, all prepared variables can be loaded into a dataframe
# automatically by calling magnoliaResults()
df2 <- magnoliaResults(mdl)
head(df2)


## ---- fig.show='hold'---------------------------------------------------------
code = "model VanderPol
derivative        

    cinterval cint = 0.01

    constant xic = -2.0, xdic = 4.0

    constant mu = 2.0
    xdd = mu*(1 - x^2)*xd - x
 
    xd  = integ(xdd, xdic)
    x   = integ(xd, xic)

    constant tstop = 10.0        
    termt(t >= tstop, 'Stopped on time limit')    

end ! derivative    
end ! model"

# Build the model
# For larger models, it's more convenient to have the model
# code in a separate file.  In this case, use the "filename"
# argument of the magnoliaBuild function to specify the name
# of the file to be built.
mdl <- magnoliaBuild(filename = "VanderPol.csl")

# Indicate which model outputs will be logged
# As an alternative to indicating which outputs should be
# logged one at a time, the "prepareAll" method of the model
# object can be used to have all outputs logged.
# For large or complex models though, logging all variables
# can lead to longer simulation runtimes.
mdl$prepareAll()

# Adjust the stopping time to 20.0
mdl$tstop <- 20

# Data frame used to hold the results of individual simulation runs
sims <- data.frame()

for (i in 1:15)
{
    # Generate some random initial values for x and xd
    mdl$xic  <- runif(1, min=-3, max=3)
    mdl$xdic <- runif(1, min=-3, max=3)

    # Run the model
    mdl$run()

    # Get time histories of variables we want to plot and
    # put into a temporary data frame. 
    # We'll need a field to uniquely identify each sim run
    # when we plot the results using ggplot below.
    df <- data.frame(
      ID = i,
      X  = mdl$history("x"),
      XD = mdl$history("xd")
    ) 
    
    # Append the current simulation results to the collection
    sims <- sims %>% dplyr::bind_rows(df)
}

# Convert ID to a factor and sort the data
sims <- sims %>% dplyr::mutate(ID = factor(ID))

# Make a phase plot using the collected sim runs
ggplot(data = sims) +
  geom_path(aes(x = X, y = XD, color = ID), size = 1) +
  labs(title = "Van der Pol Oscillator, Phase Plot", x = "X", y = "dX/dt") +
  theme_bw() +
  theme(legend.position = "none")


