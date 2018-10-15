%% STEP 1 Initial data generation
clc; clear;close all
Folder_name = [pwd,'\example\'];  % folder location
addpath(genpath(pwd)) % folder that contains ImageCN package
Filemane = 'demo_movie.tif'; % file mane
frame_rate = 20; % frame rate
FileGeneration(Folder_name,Filemane,frame_rate);
%% STEP 2 Reference image generation
RefGeneration(Folder_name)
%% STEP 3 ROI detection
clc
Ref_th = 0.0; % threshold  of acitcity feature
Ave_th = -0.4; % threshold  of morphological structure
D = 6;         % diameter of neuron
ROIGeneration(Folder_name,Ref_th,Ave_th,D)
%% STEP 4 Calcium signal Generation
CaSigGeneration(Folder_name);
%% STEP 5 Spike detection
PeakThreshold = 0.05; % threshold of delta_F/F
PeakDetection(Folder_name,PeakThreshold)
Peak3D(Folder_name)
%% STEP 6 Manual selection of signals 
% Click the left mouse button to delete a point
% Click the right mouse button add a point
% Press 'Enter' to go next
% Click the middle mouse button to go back
PeakManualSelection(Folder_name)