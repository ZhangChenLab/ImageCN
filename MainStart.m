%% Initial data generation
clc; clear;close all
Path = ('F:\data\');  % folder location
filemane = 'Image_0001_0001_B22.tif'; % file mane
frame_rate = 20.4; % frame rate
FileGeneration(Path,filemane,frame_rate);
%% Reference image generation
RefGeneration(Path)
%% ROI detection
Ref_th = 0.0; % sensitive of acitcity
Ave_th = -0.45; % sensitive of morphology
ROIGeneration(Path,Ref_th,Ave_th)
%% Calcium signal Generation
CaSigGeneration(Path);
%% Spike detection
PeakThreshold = 0.05; % sensitive of delta_F/F
PeakDetection(Path,PeakThreshold)
Peak3D(Path)
%% Manual selection of signals
PeakManualSelection(Path)