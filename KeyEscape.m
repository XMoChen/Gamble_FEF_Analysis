% Query keycodes:
esc=KbName('ESCAPE');



if keyIsDown==1 && keyCode(esc)
    % Abort:
    ShowCursor;
    Screen('CloseAll');
    ListenChar(1);
    fprintf('Aborted.\n');
    Eyelink('StopRecording');
    Eyelink('CloseFile');
end