%% STEP 1 Initial data generation
clc; clear;close all
Folder_name = 'F:\';  % folder location
Filemane = '*.tif'; % file mane
ImageCN_package = '...\ImageCN';  % folder that contains ImageCN package
addpath(genpath(ImageCN_package))
frame_rate = 20; % frame rate
FileGeneration(Folder_name,Filemane,frame_rate);
%% STEP 2 Reference image generation
RefGeneration(Folder_name)
%% STEP 3 ROI detection
Ref_th = -0.0; % threshold  of acitcity feature
Ave_th = -0.0; % threshold  of morphological structure
D = 6;         % diameter of neuron
ROIGeneration(Folder_name,Ref_th,Ave_th,D)
%% STEP 4 Calcium signal Generation
CaSigGeneration(Folder_name);
%% STEP 5 Spike detection
PeakThreshold = 0.05; % threshold of delta_F/F
PeakDetection(Folder_name,PeakThreshold)
Peak3D(Folder_name)
%% STEP 6 Manual selection of signals
% This step uses crosshairs to delete or add peak points
% Click the left mouse button to delete a point
% Click the right mouse button add a point
% Press 'Enter' to see the results in lower subplot, and stop using the crosshairs
% Press 'Enter' again to go next
% Click the middle mouse button to go back to the previous trace
PeakManualSelection(Folder_name)