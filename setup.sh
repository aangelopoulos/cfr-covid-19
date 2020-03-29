# Make the numpy_data directory for R
mkdir numpy_data
# Just setup the COVID-19 folder, or update it if it exists.
if [ -d "./COVID-19/csse_covid_19_data" ]
then
    echo "Updating contents of COVID-19."
    cd COVID-19
    git stash
    git pull
    cd ..
else
    echo "Cloning the COVID-19 JHU repository."
    if [ -d "./COVID-19" ]
    then
        rm -r COVID-19
    fi
    git clone git@github.com:CSSEGISandData/COVID-19.git
fi

# Make sure that South Korea is correctly named.
echo "Making sure South Korea named correctly."
find ./COVID-19 \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/"Korea, South"/South Korea/g'

# Make sure all data can be read by python
for d in $(find ./ -maxdepth 4 -type d -not -path '*/\.*')
do
  touch $d/__init__.py
  echo $d
done
python process_data.py
python process_data_bystate.py
