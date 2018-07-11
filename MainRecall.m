%% Initial data generation
clc; clear;close all
Path = ('F:\data\software\program\20171122');  % folder location
% Path=FileRecall(Path);
%% Reference image generation
RefGeneration(Path)
%% ROI detection
ROIThreshold=0.03; % sensitive of ROI
ROIGeneration(Path,ROIThreshold)
%% Calcium signal Generation
FilterThreshold=0.4;
CaSigGeneration(Path,FilterThreshold);
PeakThreshold=10.000; % sensitive of delta_F/F
PeakDetection(Path,PeakThreshold)
Peak3D(Path)
%% Manual selection of signals
PeakManualSelection(Path)