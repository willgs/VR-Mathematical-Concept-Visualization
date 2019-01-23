%   MATLAB VISUALIZATION IN VR
%
%   Description: This is the central bus architecture, which consists
%   of API methods to be used from the MATLAB UI
%
%
%

classdef CentralBus
   
   methods (Static)
       
      function returnFile = grabFile()
          % This function will grab the file name from the system UI's file
          % chooser
         [file, ~] = uigetfile("*.txt");
         returnFile = file;
      end
      
      function path = grabPath()
          path = uigetdir();
      end
      
      function returnedObjectFile = initiateConversion(file, processedLocation)
          % This function will do the necessary pre-processing steps for
          % the conversion algorithm, then call the function to convert
          
          %NEED FINISHED CONVERSION ALGORITHM TO IMPLEMENT THIS METHOD
      end
      
   end
end


