# Chinese Remainder Theorem based RADAR with Fast Fourier in practice

Computing RADAR distance based on multiple incoming radiowaves' imprecise phase measurements, as remainders, which result in real numbers, with the help of superposition and interference.

CRT enables to calculate a natural number if only several of its moduluses by relative prime naturals are known. It comes from number theory, I learned about it from cryptography. Then I realized, this could theoretucally be used to measure distance by multiple radiowaves without time of flight measurement, and if triangulation was used, then even without a precise direction finding antennae.

As I searched for such solutions in practice I repeatedly bumped into something called robust CRT, which was meant to deal with the problem, when the some phase measurements' muduluses are around 0, and with the measurement error it is impossible to determine if there was a wrap-around or not. This problem can completely fake a measurement, that say has 3 or 5 such less well defined inputs, and as such has to decide between 2^3=8 o4 2^5=32 possible outputs.

Robust CRTs are really utterly complicated deep maths mostly, and begun thinking if there is a practically useful engineering solution, that is easier to implement.

This is how I realized, that if radio waves were sent out with phase 0, and received with diverse phases, then reversing this process results in the strongest interference at the distance of the origin. And because superposition applies, thisbcan perfectl, be simulated by adding the Fourier transforms of binary signals that are only high at and around the phase measurement result with its imprecision...

Further developments are possible too:
- replacing high binary values with the actualy distributions of phase errors should improve the inteference results
- a complete spatial wave does not need to be computed, the Fourier of a single period combined with shifting properties is enough to process the input, and then only the inverse FFT's cost and the search for its highest energy peak remains as the bulk of computation cost
