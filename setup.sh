#!/bin/bash

# Tracker Project Setup
echo "  Attendance System Setup"
echo "___________________________"

# Prompt for parent directory name
read -p "Enter your project folder name: " parent

if [ -z "$parent" ]; then
   echo "Error: Project folder name is empty. Exiting....."
   exit 1
fi

# Parent directory variable
project_dir="attendance_tracker_${parent}"

# SIGINT trap
cleanup() {
  echo ""
  echo "Ctrl+C detected. Archiving current project state...."

  arc="attendance_tracker_${parent}_archive"

  if [ -d "$project_dir" ]; then
     tar -czf "$arc.tar.gz" "$project_dir"
     echo "Archive created."

     rm -rf "$project_dir"
     echo "Incomplete directory removed."

  else
     echo "Nothing to archive, project directory not yet created"
  fi

  exit 1
}

trap cleanup SIGINT

# Creating project directory structure

structure() {
  # Checking if the directory exists
  if [ -d "$project_dir" ]; then
     echo "Directory ${project_dir} already exists."
     read -p "Do you want to remove it and create a new directory? (y/n): " confirm

     if [ "$confirm" = "y" ]; then
         rm -rf "$project_dir"
         echo "Directory removed. Proceeding....."
     else
         echo "Exiting....."
         exit 1
     fi
  fi
  # Creating Directory and subdirectories

  mkdir -p "$project_dir" # Parent directory
  mkdir -p "$project_dir/Helpers" "$project_dir/reports" # Subdirecories

  echo "Directories and Subdirectories Created"
}

# Running the project structure function
structure()


# Checking for the pre-made files
if [ ! -f attendance_checker.py ] || [ ! -f assets.csv ] || [ ! -f config.json ] || [ ! -f reports.log ]; then 
  echo "Missing file(s) required for the setup to complete. Exiting....."
  exit 1
fi

# Copying the pre-made files to the instructed paths
cp attendance_checker.py "$project_dir/"
cp assets.csv "$project_dir/Helpers/"
cp config.json "$project_dir/Helpers/"
cp reports.log "$project_dir/reports/"

echo "Files Copied"

# Dynamic Configuration
echo "The default warning value is set to 75%, and the default failure value is set to 50%."
read -p "Do you want to change the default values? (y/n): " config

warning=75
failure=50

if [ "$config" = "y" ]; then
  read -p "Enter a new warning value: " new_warning
  read -p "Enter a new failure value: " new_failure

  if [ -n "$new_warning" ]; then
     warning="$new_warning"
  fi

  if [ -n "$new_failure" ]; then
     failure="$new_failure"
  fi
fi

# Conditioning the input to accept only numbers
num() {
  case "$1" in
    ''|*[!0-9]*)
      return 1 ;;
    *)
      return 0 ;;
  esac
}

if ! num "$warning" || ! num "$failure"; then
  echo "Both warning and failure values must be only numbers (0-100)"
  exit 1
fi

# Conditioning the scope of the numbers to be accepted
if [ "$warning" -lt 0 ] || [ "$warning" -gt 100 ] || [ "$failure" -lt 0 ] || [ "$failure" -gt 100 ]; then
  echo "Both warning and failure values must be between 0-100"
   exit 1
fi

if [ "$warning" -le "$failure" ]; then
  echo "Warning value must be greater than failure value"
  exit 1
fi

# Config file directory
config_path="$project_dir/Helpers/config.json"


# Substituting the thresholds using sed
sed -i "s/\"warning\": *[0-9]\+/\"warning\": $warning/" "$config_path" # For warning
sed -i "s/\"failure\": *[0-9]\+/\"failure\": $failure/" "$config_path" # For Failure

echo "Config.json updated."
# Verifying for python installation
if python3 --version >/dev/null 2>&1; then
  echo "Python3 is installed."
else
  echo "Warning: python3 is not installed."
fi
#!/bin/bash

# Tracker Project Setup
echo "  Attendance System Setup"
echo "___________________________"

# Prompt for parent directory name
read -p "Enter your project folder name: " parent

if [ -z "$parent" ]; then
   echo "Error: Project folder name is empty. Exiting....."
   exit 1
fi

# Parent directory variable
project_dir="attendance_tracker_${parent}"

# SIGINT trap
cleanup() {
  echo "Ctrl+C detected. Archiving current project state...."

  arc="attendance_tracker_${parent}_archive"

  if [ -d "$project_dir" ]; then
     tar -czf "$arc.tar.gz" "$project_dir"
     echo "Archive created."

     rm -rf "$project_dir"
     echo "Incomplete directory removed."

  else
     echo "Nothing to archive, project directory not yet created"
  fi

  exit 1
}

trap cleanup SIGINT

# Creating project directory structure

structure() {
  # Checking if the directory exists
  if [ -d "$project_dir" ]; then
     echo "Directory ${project_dir} already exists."
     read -p "Do you want to remove it and create a new directory? (y/n): " confirm

     if [ "$confirm" = "y" ]; then
         rm -rf "$project_dir"
         echo "Directory removed. Proceeding....."
     else
         echo "Exiting....."
         exit 1
     fi
  fi
  # Creating Directory and subdirectories

  mkdir -p "$project_dir" # Parent directory
  mkdir -p "$project_dir/Helpers" "$project_dir/reports" # Subdirecories

  echo "Directories and Subdirectories Created"
}

# Running the project structure function
structure()


# Checking for the pre-made files
if [ ! -f attendance_checker.py ] || [ ! -f assets.csv ] || [ ! -f config.json ] || [ ! -f reports.log ]; then
  echo "Missing file(s) required for the setup to complete. Exiting....."
  exit 1
fi

# Copying the pre-made files to the instructed paths
cp attendance_checker.py "$project_dir/"
cp assets.csv "$project_dir/Helpers/"
cp config.json "$project_dir/Helpers/"
cp reports.log "$project_dir/reports/"

echo "Files Copied"

# Dynamic Configuration
echo "The default warning value is set to 75%, and the default failure value is set to 50%."
read -p "Do you want to change the default values? (y/n): " config

warning=75
failure=50

if [ "$config" = "y" ]; then
  read -p "Enter a new warning value: " new_warning
  read -p "Enter a new failure value: " new_failure

  if [ -n "$new_warning" ]; then
     warning="$new_warning"
  fi

  if [ -n "$new_failure" ]; then
     failure="$new_failure"
  fi
fi

# Conditioning the input to accept only numbers
num() {
  case "$1" in
    ''|*[!0-9]*)
      return 1 ;;
    *)
      return 0 ;;
  esac
}

if ! num "$warning" || ! num "$failure"; then
  echo "Both warning and failure values must be only numbers (0-100)"
  exit 1
fi

# Conditioning the scope of the numbers to be accepted
if [ "$warning" -lt 0 ] || [ "$warning" -gt 100 ] || [ "$failure" -lt 0 ] || [ "$failure" -gt 100 ]; then
  echo "Both warning and failure values must be between 0-100"
   exit 1
fi

if [ "$warning" -le "$failure" ]; then
  echo "Warning value must be greater than failure value"
  exit 1
fi

# Config file directory
config_path="$project_dir/Helpers/config.json"


# Substituting the thresholds using sed
sed -i "s/\"warning\": *[0-9]\+/\"warning\": $warning/" "$config_path" # For warning
sed -i "s/\"failure\": *[0-9]\+/\"failure\": $failure/" "$config_path" # For Failure

echo "Config.json updated."
# Verifying for python installation
if python3 --version >/dev/null 2>&1; then
  echo "Python3 is installed."
else
  echo "Warning: python3 is not installed."
fi

# Success message
echo "project setup completed."
echo "Run the project by executing: cd \"$project_dir\" && python3 attendance_checker.py"
