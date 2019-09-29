%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  1D FLOW - Y DIRECTION   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Miquel Altadill Llasat  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
more off
InputData

tic;
mesh=UniformMesh(domainPoints,meshSizes,v0);
fprintf('MeshTime %f\n',toc); tic;

physProp=PhysProp(mesh,rhogamma,cp,k,rho);
fprintf('PhysPropTime %f\n',toc); tic;

boundCond=BoundCond(initProp, leftProp, rightProp);
fprintf('BoundCondTime %f\n',toc); tic;

tcd2D=TransientConvectionDiffusion2D(mesh, physProp, boundCond, timeStep, initProp, refTime);
fprintf('CreateTHC2DTime %f\n',toc); tic;

tcd2D.solveTime( maxIter, maxDiff,PostProcess,maxtDiff,Pe);
fprintf('Solver Time %f\n',toc); 
