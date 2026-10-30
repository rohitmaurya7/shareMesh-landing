@echo off
setlocal
cd /d "%~dp0"

if not exist "agent.py" (
    echo Error: worker.bat must be in the agent folder beside agent.py.
    pause
    exit /b 1
)

if not exist "requirements.txt" (
    echo Error: requirements.txt was not found in the agent folder.
    pause
    exit /b 1
)

if not exist ".env" (
    echo Error: .env was not found. Add your scheduler URL and user token first.
    pause
    exit /b 1
)

where py >nul 2>nul
if errorlevel 1 (
    echo Error: Python 3.10 or newer is required. Install Python and try again.
    pause
    exit /b 1
)

if not exist "venv\Scripts\python.exe" (
    echo Creating Python virtual environment...
    py -3 -m venv venv
    if errorlevel 1 (
        echo Error: Could not create the Python virtual environment.
        pause
        exit /b 1
    )
)

echo Installing agent requirements...
"venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo Error: Could not install agent requirements.
    pause
    exit /b 1
)

echo Starting ShareMesh worker...
"venv\Scripts\python.exe" agent.py
set "worker_exit_code=%errorlevel%"
pause
exit /b %worker_exit_code%
