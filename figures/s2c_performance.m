%
% S2F fitting performance in different imaging conditions
% 
% Figure 4A, S3BEFG, Wei et al., 2020
%
% 1. File 'ParamsFitCells_S2CModel_nofix.mat' can be generated by code
%       ../groundtruth_dat_fit/run_fit_s2c_models.m using sigmoid function
%       fit.
% 2. File 'ParamsFitCells_S2CModel_linear_nofix.mat' can be generated by code
%       ../groundtruth_dat_fit/run_fit_s2c_models.m using line function
%       fit.
% 3. File 'ParamsFitCells_S2CModel_Fmfix.mat' can be generated by code
%       ../groundtruth_dat_fit/run_fit_s2c_models.m using hill function
%       fit.
% 4. Create Plots folder if necessary for PlotDir
%
% author: Ziqiang Wei
% email: weiz@janelia.hhmi.org
%
% 

%% Load fitted parameters
addpath('../Func/plotFuncs')
load('../TempDat/DataListCells.mat');
load('../TempDat/ParamsFitCells_S2CModel_linear_nofix.mat')
linearParas  = paras;
load('../TempDat/ParamsFitCells_S2CModel_sigmoid_Fmfix.mat')
sigmoidParas = paras;
load('../TempDat/ParamsFitCells_S2CModel_Fmfix.mat')
hillParas    = paras;
clear paras

expression  = {'virus', 'virus', 'transgenic', 'transgenic'};
CaIndicator = {'GCaMP6f', 'GCaMP6s', 'GCaMP6f', 'GCaMP6s'};
group    = nan(length(totCell), 1);
for nGroup = 1:length(expression)    
    indexExpression = strcmp(expression{nGroup}, {totCell.expression});
    indexCaInd      = strcmp(CaIndicator{nGroup}, {totCell.CaIndicator});
    group(indexExpression & indexCaInd)     = nGroup;
end


spk        = zeros(length(totCell), 1);
evMat      = zeros(length(totCell), 3);

for nCell  = 1:length(totCell)
    spk(nCell)      = length(totCell(nCell).spk)/240;
    evMat(nCell, 1) = linearParas(nCell).ev;
    evMat(nCell, 2) = sigmoidParas(nCell).ev;
    evMat(nCell, 3) = hillParas(nCell).ev;
end


%% Figure S3B -- EV from sigmoid fit
figure;
hold on
boxplot(evMat(:, 1), group)
ylabel('Sigmoid fit')
xlabel('Indicator groups')
set(gca, 'TickDir', 'out')
setPrint(8, 6, [PlotDir 'Boxplot_EV'], 'pdf')


%% Figure S3E -- spike rate
figure;
hold on
boxplot(spk, group)
ylabel('Spike (/s)')
xlabel('Indicator groups')
set(gca, 'TickDir', 'out')
setPrint(8, 6, [PlotDir 'Boxplot_spike_rates'], 'pdf')


%% Figure S3G left -- EV from linear vs sigmoid fit
figure;
hold on
scatter(evMat(:, 1), evMat(:, 2), [], group)
plot([0 1], [0 1], 'k')
ylabel('Sigmoid fit')
xlabel('Linear fit')
set(gca, 'TickDir', 'out')
setPrint(8, 6, [PlotDir 'Performance_linear'], 'pdf')

%% Figure S3G right -- EV from hill vs sigmoid fit
figure;
hold on
scatter(evMat(:, 3), evMat(:, 2), [], group)
plot([-0.4 1], [-0.4 1], 'k')
ylabel('Sigmoid fit')
xlabel('Hill fit')
set(gca, 'TickDir', 'out')
setPrint(8, 6, [PlotDir 'Performance_hill'], 'pdf')

%% Figure S3F -- EV from sigmoid fit vs cell spike rate
figure;
hold on
scatter(spk, evMat(:, 2), [], group)
ylabel('Sigmoid fit')
xlabel('Spike (/s)')
set(gca, 'TickDir', 'out')
setPrint(8, 6, [PlotDir 'Performance_spk'], 'pdf')

%% Figure 4A -- example cells
figure
subplot(3, 1, 1)
nCell  = 42;
plot(totCell(nCell).CaTime, totCell(nCell).dff)
hold on
plot(totCell(nCell).CaTime, sigmoidParas(nCell).fitCaTraces)
gridxy(totCell(nCell).spk, [])
xlim([50 150])

subplot(3, 1, 2)
nCell   = 29;
plot(totCell(nCell).CaTime, totCell(nCell).dff)
hold on
plot(totCell(nCell).CaTime, sigmoidParas(nCell).fitCaTraces)
gridxy(totCell(nCell).spk, [])
xlim([100 200])

subplot(3, 1, 3)
nCell   = 37;
plot(totCell(nCell).CaTime, totCell(nCell).dff)
hold on
plot(totCell(nCell).CaTime, sigmoidParas(nCell).fitCaTraces)
gridxy(totCell(nCell).spk, [])
xlim([100 200])
setPrint(8, 18, [PlotDir 'ExampleNeuron'], 'pdf')