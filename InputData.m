%---------------INPUT DATA----------------
%-----------------------------------------

%Domain lengths
%------------------------
domainPoints=[0 0.1; 0 0.1];       %First  row for X dim
                                   %Second row for Y dim                       

%Mesh sizes
%--------------------
meshSizes=[200 2];

%Initial properties 
%---------------------
initProp=333.15;
leftProp = 273.15;
rightProp = 373.15;
v0=-0.005;


%Time inputs
%---------------------
timeStep=1;
refTime=5.0e3;
maxtDiff=1e-4;

%Fluid properties (Air T=50ºC & P=101325Pa)
%-----------------------------

rho=1.059545;
cp=1007.04;
k=0.029155;
gamma=k/cp;
rhogamma = rho/gamma;

Pe = rho*v0*(domainPoints([1],[2])-domainPoints([1],[1]))/gamma;


%Iterative solver parameters
%-----------------------------
maxIter=1e4;
maxDiff=1e-4;


%Postprocessor Options
%-----------------------------
PostProcess = 1;    % 0 for no plots
                    % 11 for evolutive plot
                    % 1 for plots


