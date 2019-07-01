function varargout = gui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

end

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;
end

% ================================================================ %
% Aux Functions
    
    % --- Shows image on Axis1 --- %
    function ShowImageAxis1(im_now, hObject, handles)

        % Get size of axes1
        set(handles.axes1,'Units','pixels');
        resizePos = get(handles.axes1,'Position');
                
        % Check if transparency box is ticked
        transparent = get(handles.transparencyBox, 'Value');
        
        % Resize and show im_orig in axes1
        im_now = imresize(im_now, [resizePos(3) resizePos(3)]);
        size(im_now)
        axes(handles.axes1);
        imageHandle = imshow(im_now);
       
        set(imageHandle, 'ButtonDownFcn', {@my_callback, handles})
        
        if transparent
            alpha(0.25)
        end
        
        set(handles.axes1,'Units','normalized');
        handles.im_now = im_now;
        
        guidata(hObject, handles);
        
    end
    
    function my_callback(dummy1, dummy2, handles)
        
        cursorPoint = get(handles.axes1, 'CurrentPoint');
        curX = cursorPoint(1,1);
        curY = cursorPoint(1,2);
        %disp(curX)
        %disp(curY)
        
                
        if isequal(get(handles.merge,'value'), 1)
            
            %size(handles.im_labeled)
            %rgbColor = impixel(handles.im_labeled, curX, curY);
            %disp(rgbColor)
            
        end
        
    return;
    end
   
    function axes1_ButtonDownFcn(objectHandle, eventData, handles)
        disp('clicked axes1')
     
    end
       
    function ShowImageAxis3(im_now, handles)

        % Get size of axes1
        set(handles.axes3,'Units','pixels');
        resizePos = get(handles.axes3,'Position');

        % Resize and show im_orig in axes1
        im_now = imresize(im_now, [resizePos(3) resizePos(3)]);
        axes(handles.axes3);

        imshow(im_now);
        set(handles.axes3,'Units','normalized');

    end
    
    function VisuButtons(value, handles)
    
        set(handles.tgbtnOriginal, 'Value', 0);
        set(handles.tgbtnFiltered, 'Value', 0);
        set(handles.tgbtnBinarized, 'Value', 0);
        set(handles.tgbtnSegmented, 'Value', 0);
        
        switch value
            case 1
                set(handles.tgbtnOriginal, 'Value', 1);
            case 2
                set(handles.tgbtnFiltered, 'Value', 1);
            case 3
                set(handles.tgbtnBinarized, 'Value', 1);
            case 4
                set(handles.tgbtnSegmented, 'Value', 1);
        end
    end
    
    % Transparency box Callback
    function transparencyBox_Callback(hObject, eventdata, handles)

        % Check if turned on or off
        %transparent = get(handles.transparencyBox, 'Value');
        
        % Check which toggle btn is on
        if get(handles.tgbtnOriginal, 'Value')
            ShowImageAxis1(handles.im_orig, hObject, handles)
        elseif get(handles.tgbtnFiltered, 'Value')
            ShowImageAxis1(handles.im_filtered, hObject, handles)
        elseif get(handles.tgbtnBinarized, 'Value')
            ShowImageAxis1(handles.im_morphed, hObject, handles)
        elseif get(handles.tgbtnSegmented, 'Value')
            ShowImageAxis1(handles.im_segmented, hObject, handles)
        end
    
    end
    
% ================================================================= %
% Push Buttons

    % Push Button Select Image
    function pbSelectImage_Callback(hObject, eventdata, handles)

        [file,path] = uigetfile({'*.jpg';'*.png'}, 'File Selector');

        if isequal(file,0)
           disp('User selected Cancel');
        else
            disp(['User selected ', fullfile(path,file)]);

            % Read image
            im_orig = imread(fullfile(path,file));

            % Assign the value if they didn't click cancel.
            handles.im_orig = im_orig;
            handles.im_now = im_orig;
            handles.im_filtered = im_orig;
            handles.im_segmented = im_orig;
            ShowImageAxis1(im_orig, hObject, handles);
            ShowImageAxis3(im_orig, handles);

            % Update handles
            guidata(hObject, handles);

        end

        % If someone selects another image, restart stuff
        set(handles.treeCountBox,'string',num2str(0));
        set(handles.contrastCheckBox,'value',0);
        set(handles.atmCheckBox,'value',0);
        VisuButtons(1, handles);
        
    end
    
    % Toggle Button Show Original Image
    function tgbtnOriginal_Callback(hObject, eventdata, handles)

        im_orig = handles.im_orig;
        ShowImageAxis1(im_orig, hObject, handles);
        
    end  
    
    % Toggle Button Show Filtered Image
    function tgbtnFiltered_Callback(hObject, eventdata, handles)

        im_filtered = handles.im_filtered;
        ShowImageAxis1(im_filtered, hObject, handles);

    end
   
    % Toggle Button Show Binarized Image
    function tgbtnBinarized_Callback(hObject, eventdata, handles)
    
        im_morphed = handles.im_morphed;
        ShowImageAxis1(im_morphed, hObject, handles);
        
    end
    
    % Toggle Button Show Segmented Image
    function tgbtnSegmented_Callback(hObject, eventdata, handles)
        
        im_segmented = handles.im_segmented;
        ShowImageAxis1(im_segmented, hObject, handles);
        
    end
    
% ================================================================= %
% Filtering
    
    % --- Contrast Enhancement
    function contrastCheckBox_Callback(hObject, eventdata, handles)

        set(gcf,'Pointer','watch');
        drawnow;
    
        if isequal(get(handles.contrastCheckBox,'value'), 1)
            im_now = handles.im_now;
            im_now = contrastEnhancement(im_now, 0.002);
            
            handles.im_filtered = im_now;
            handles.im_now = im_now;
            guidata(hObject, handles);
            
            VisuButtons(2, handles);
            ShowImageAxis1(im_now, hObject, handles);
                        
        else
            if isequal(get(handles.atmCheckBox,'value'), 1)
                im_now = handles.im_now;
                im_now = imreducehaze(im_now);
                
                handles.im_filtered = im_now;
                handles.im_now = im_now;
                guidata(hObject, handles);
                
                VisuButtons(2, handles);
                ShowImageAxis1(im_now, hObject, handles);
            else
                im_now = handles.im_orig;
                
                handles.im_now = im_now;
                handles.im_filtered = im_now;
                guidata(hObject, handles);
                
                VisuButtons(1, handles);
                ShowImageAxis1(im_now, hObject, handles);
            end
        end
        
        set(gcf,'Pointer','arrow');
        drawnow;
        
    end

    % --- Reduce Atmosphere Haze
    function atmCheckBox_Callback(hObject, eventdata, handles)
    
        set(gcf,'Pointer','watch');
        drawnow;
    
        if isequal(get(handles.atmCheckBox,'value'), 1)
            im_now = handles.im_now;
            im_now = imreducehaze(im_now);
            
            handles.im_filtered = im_now;
            handles.im_now = im_now;
            guidata(hObject, handles);
            
            VisuButtons(2, handles);
            ShowImageAxis1(im_now, hObject, handles);
            
        else
            if isequal(get(handles.contrastCheckBox,'value'), 1)
                im_now = handles.im_now;
                im_now = contrastEnhancement(im_now, 0.002);
                
                handles.im_filtered = im_now;
                handles.im_now = im_now;
                guidata(hObject, handles);
                
                VisuButtons(2, handles);
                ShowImageAxis1(im_now, hObject, handles);    
            else
                im_now = handles.im_orig;
                
                handles.im_filtered = im_now;
                handles.im_now = im_now;
                guidata(hObject, handles);
                
                VisuButtons(1, handles);
                ShowImageAxis1(im_now, hObject, handles);               
            end
        end

        set(gcf,'Pointer','arrow');
        drawnow;
        
    end

% ================================================================= %
% Binarizing

    % --- Apply Button
    function pbtnApplyBin_Callback(hObject, eventdata, handles)
    
        set(gcf,'Pointer','watch');
        drawnow;
    
        % Radio button kMeans is selected
        if isequal(get(handles.rbtnKMeans, 'Value'), 1)
          
            nColors = get(handles.kMeansMenu, 'Value') + 1;
            im_filtered = handles.im_filtered;
            labels = kmeansColor(im_filtered, nColors);
            handles.im_labeled = labels;
            
            % Turn layer1 white and the rest black
            im_binarized = selectLayers(labels, 2:nColors, 1);
            handles.im_binarized = im_binarized;       
            handles.im_morphed = im_binarized;
            
            % Reload kMeans list
            klist = 1:nColors;
            set(handles.kMeansList, 'String', strtrim(cellstr(num2str(klist'))'));
            
            % Save stuff
            guidata(hObject, handles);
            
            % Reload stuff
            VisuButtons(3, handles);
            ShowImageAxis1(im_binarized, hObject, handles);
        end
        
        % Radio button Otsu is selected
        if isequal(get(handles.rbtnOtsu, 'Value'), 1)
           
            im_filtered = handles.im_filtered;
            im_binarized = otsuMorph(im_filtered, 200, 2, 4);
            
            handles.im_binarized = im_binarized;
            handles.im_morphed = im_binarized;
            guidata(hObject, handles);           

            VisuButtons(3, handles);
            ShowImageAxis1(im_binarized, hObject, handles);
        end
          
        % If someone selects another binarizing technique, zero count
        set(handles.treeCountBox,'string',num2str(0));
        
        set(gcf,'Pointer','arrow');
        drawnow;
       
    end

    % --- Executes on selection change in kMeansList.
    function kMeansList_Callback(hObject, eventdata, handles)

        % Get selected items
        contents = (get(hObject,'Value'));
        str_contents = cellstr(get(hObject,'String'));
        
        % list1 = selected items
        % list0 = all items - selected items
        list1 = str_contents(contents);
        list0 = erase(str_contents, list1);
        
        list0 = str2num(join(string(list0)));
        list1 = str2num(join(string(list1)));
                
        % Paint the selected with white and the rest with black
        labeledImage = handles.im_labeled;
        im_binarized = selectLayers(labeledImage, list0, list1);
        handles.im_binarized = im_binarized;       
        handles.im_morphed = im_binarized;       
        
        % Save stuff
        guidata(hObject, handles);

        % Reload stuff
        VisuButtons(3, handles);
        ShowImageAxis1(im_binarized, hObject, handles);
        
        % If someone selects another image, zero count
        set(handles.treeCountBox,'string',num2str(0));
    end
    
    % --- Executes on selection change in kMeansList.
    function kMeansMenu_Callback(hObject, eventdata, handles)

    end
    
% ================================================================= %
% Morph Operations    
    
    % --- Executes on button press in applyMorph.
    function applyMorph_Callback(hObject, eventdata, handles)
        
        im_morphed = handles.im_morphed;
        
        contents = get(handles.operMenu,'String'); 
        operation = contents{get(handles.operMenu,'Value')};
        display(operation)
        
        contents = get(handles.seMenu,'String'); 
        struct_elem = contents{get(handles.seMenu,'Value')};
        display(operation)
        
        r = str2double(get(handles.radiusEdit, 'String'));
        display(r)        
        
        % Build structuring element
        switch struct_elem
            case 'Disk'
                se = strel('disk', r);
            case 'Diamond'
                se = strel('diamond', r);
            case 'Octagon'
                se = strel('octagon', r);
            case 'Square'
                se = strel('square', r);
        end
        
        % Select morph operation
        switch operation
            case 'Closing'
                im_morphed = imclose(im_morphed, se);
            case 'Opening'
                im_morphed = imopen(im_morphed, se);
            case 'Filter CC'
               
        end
        
        handles.im_morphed = im_morphed;
        
        % Save stuff
        guidata(hObject, handles);

        % Reload stuff
        VisuButtons(3, handles);
        ShowImageAxis1(im_morphed, hObject, handles);
    end
    
    % --- Executes on button press in restartMorph.
    function restartMorph_Callback(hObject, eventdata, handles)
    
        im_binarized = handles.im_binarized;
        handles.im_morphed = im_binarized;
 
        % Save stuff
        guidata(hObject, handles);

        % Reload stuff
        VisuButtons(3, handles);
        ShowImageAxis1(im_binarized, hObject, handles);
        
    end
    
% ================================================================= %
% Dist. Transform and Watershed

    % --- Executes on button press in btnWatershed.
    function btnWatershed_Callback(hObject, eventdata, handles)
    
        set(gcf,'Pointer','watch');
        drawnow;
    
        im_binarized = handles.im_morphed;
        sensitivity = get(handles.distTMenu, 'Value');
        [RGB_label, im_labeled, count] = dtWatershed(im_binarized, sensitivity);
        
        handles.im_labeled = im_labeled;
        handles.im_segmented = RGB_label;
        guidata(hObject, handles);        
        
        ShowImageAxis1(RGB_label, hObject, handles);
        VisuButtons(4, handles);
        set(handles.treeCountBox,'string',num2str(count));
        
        set(gcf,'Pointer','arrow');
        drawnow;
        
    end
    
    % --- Executes on button press in merge.
    function merge_Callback(hObject, eventdata, handles)
        
        BW2 = bwselect(handles.im_segmented, 4)
    
    end

% ================================================================= %

    % --- Executes on selection change in distTMenu.
    function distTMenu_Callback(hObject, eventdata, handles)
    end

    function distTMenu_CreateFcn(hObject, eventdata, handles)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end
    
    % --- Executes during object creation, after setting all properties.
    function kMeansMenu_CreateFcn(hObject, eventdata, handles)
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end

    % --- Executes during object creation, after setting all properties.
    function kMeansList_CreateFcn(hObject, eventdata, handles)
       
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end

    function treeCountBox_Callback(hObject, eventdata, handles)
    % hObject    handle to treeCountBox (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of treeCountBox as text
    %        str2double(get(hObject,'String')) returns contents of treeCountBox as a double

    end
    
    % --- Executes during object creation, after setting all properties.
    function treeCountBox_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    end

% ================================================================= %
    
    % --- Executes on button press in transparencyBox.
    function checkbox13_Callback(hObject, eventdata, handles)
    % hObject    handle to transparencyBox (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of transparencyBox
    end

    % --- Executes on selection change in operMenu.
    function operMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to operMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns operMenu contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from operMenu
    end

    % --- Executes during object creation, after setting all properties.
    function operMenu_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to operMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    end

    % --- Executes on selection change in seMenu.
    function seMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to seMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns seMenu contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from seMenu
    end

    % --- Executes during object creation, after setting all properties.
    function seMenu_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to seMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    end


    function radiusEdit_Callback(hObject, eventdata, handles)
    % hObject    handle to radiusEdit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of radiusEdit as text
    %        str2double(get(hObject,'String')) returns contents of radiusEdit as a double
    end

    % --- Executes during object creation, after setting all properties.
    function radiusEdit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to radiusEdit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    end
