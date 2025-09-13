# EENG484Labs
Lab code for EENG 484: Advanced Digital Design at Mines

All supplemental scripts and lab material created by Christopher Coulston and available at https://coulston.github.io/Advanced-Digital-Design/index.html

Lab1 - EnhancedPWM
  Created an enhancedPWM module capable of producing a pwm signal whose period is 256 counts and has a variable duty cycle that depends on given input. Duty cycle loading only happens when internal counter rolls over to 0, thrown out as a rollOver output of 1 when this event occurs, so as to prevent duty cycle changes to occur in the middle of a waveform.  
