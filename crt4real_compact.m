% MIT License

% Copyright (c) 09 April 2022 Balazs Valer Fekete fbv81bp@outlook.hu or fbv81bp@gmail.com

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% This is a MATLAB code showing how to calculate a Chinese Remainder Theory
% based RADAR distance value safely with Fourier Transforms instead.



% DESCRIPTION

% This code computes the distance of an object similarly to the Chinese Remainder
% Theorem yet with spatial Fourier Transfroms from the phases of possibly reflected
% radio signals. It works with real numbers, not just with relative prime naturals.


% CONCEPT

% Calculating the best distance guess can be thought of as in interference problem:
% if the received signals were sent out with the respective phase delays that were
% measure, then the interference would be the strongest at the original reflection
% point. This can be simulated by Fourier transforming such signals, that only have
% a non-zero values where offset plus the wavelength plus-minus the measurements'
% imprecisions determine it. Then adding up such Fourier transforms and calculating
% the inverse Fourier transform, yields the highest peak at the original point where
% phases were aligned: in this very siimple proof of concept I calculated with the
% traced object being the source of radio signals, and all signals were sent out with
% phase 0. Summing up the Fourier series is a solution, because of superposition.


% POSSIBLE IMPROVEMENTS

% - the non-zero values in the saptial functions (variable 'a') could be replaced by
%   the measurements actual error distribution, which may give more exact results
% - there are most of time multiple spikes at the same highest maximum, yet the widest
%   one seems to be the correct guess
% - the space domain functions don't all have to be calculated for the Fourier transform,
%   the laws of Fourier calculation should be enough to calculate the measurement error
%   distributions' transform, and then caculate if it was delayed by the offset plus the
%   wavelength
% - imprecision likely varies from wavelength to wavelength

function _ = crt4real_compact(distance, wavelengths, imprecision)
  phases = real_mod(distance, wavelengths) % simulating phase measurements
  max_pos = 1
  for i = 1:size(wavelengths)(2)
    max_pos = max_pos * wavelengths(i) % maximum distance according to Chinese Remainder Theorem
  endfor
  position_line = [1:0.1:max_pos];
  lines = ones(size(wavelengths)(2),1);
  position = lines * position_line; % this helps to set up the spatial functions
  a = (real_mod(position.-phases, wavelengths) <= imprecision); % spatial functions are either 0 or 1:
  % areas with 1-s represent the measured phase and the measurements' imprecision, their interference
  % will show the best guess for the distance of the wave sources
  
  A = fft(a');
  A = A';
  CRT = A(1,:);
    for i = 2:size(A(:,1))(1)
    CRT = CRT + A(i,:); % summing up Fourier transforms so that their inverse shows the interference
  endfor
  crt = ifft(CRT');
  plot(abs(crt'))
endfunction




function ret_val  = real_mod(dividend, divisor)
  quote = dividend ./ divisor'; % number of wavelengths in the distance
  natural = floor(quote); % number of whole wavelengths
  ret_val = dividend .- natural .* divisor'; % phases are that remain after subtracting whole wavelengths
endfunction

% A simplified, easier to follow code is presented below:

function _ = crt(distance, wavelengths, imprecision)
  phases = mod(distance, wavelengths) % simulating phase measurements
  position = 1:1:30000; % this helps to set up the spatial functions
  a = (mod(position-phases(1),wavelengths(1)) <= imprecision); % spatial functions are either 0 or 1:
  b = (mod(position-phases(2),wavelengths(2)) <= imprecision); % areas with 1-s represent the measured
  c = (mod(position-phases(3),wavelengths(3)) <= imprecision); % phase and the measurements' imprecision,
  d = (mod(position-phases(4),wavelengths(4)) <= imprecision); % their interference will show the best
  e = (mod(position-phases(5),wavelengths(5)) <= imprecision); % guess for the distance of the wave sources
  A = fft(a);
  B = fft(b);
  C = fft(c);
  D = fft(d);
  E = fft(e);
  CRT = A+B+C+D+E; % summing up Fourier transforms so that their inverse shows the interference
  crt = ifft(CRT);
  plot(abs(crt))
end
