I will try to outline how to use TranslateText2 below:

TranslateText2 is a Processing file that combines two (kinda 3) functionalities into one, 
1) It reads in a text file representing the data collected on a spectrum and recreates the image of the spectrum
2) It finds the maxima of the spectrum and draws lines/text on the file to indicate where they are and their wavelength
3) It saves this image to your computer

To properly use this file, you should first fork this Github to your own branch so that you are not trying to upload
data to my Github and messing up what I have.  Once you are on your own branch, you will want to change the String
filename on line 2 to read the path to your files on your computer.  The last section of that filename is the actual
.txt file you want to read in, make sure that it is entirely correct.

Lines 1 through 38 define variables and arrays that will be needed to be used in the program.  They are roughly labelled
but are largely unalterable and essential to the functioning of the file.  Of note are the float arrays peaks, troughs, 
sortM, and unkTable (unique table).  These are tables that I attempted to use to find the peaks more efficiently, but
it ended up being a little annoying.  I will discuss this later in the document.

Lines 40 through 92 define all of the setup needed to read in a text file and set up the drawing window.  Nothing here
should require any editing.

Line 93 will likely need editing, since it extracts the file path from the filename String and then attaches a suffix
to print it above the graph, and your file path is likely different from mine.

Lines 94 through 152 should not need editing, they simply define how to draw and color the data.

Line 154 starts the custom methods I wrote to find the maxima.  getMaxY should not need editing since it is used to
scale the image from your data.

Line 164 is the meat of the maxima printing, and it is a little complicated.  It takes every set of 4 adjacent points
and calculates the slopes of the first two points and the last two points.  A maxima can only occur if the first two
points create a line with a positive slope and the next two create a line with a negative slope.  Those conditions are
then reversed to find troughs.  Theoretically very smartly written code would go between any two troughs and find the
maximum, but I ran out of time to properly fix this method.

Line 189 calculates the average Voltage of the whole graph, to determine which peaks to exclude or draw.

Line 191 calls findRelMax(find Relative Maximum, located on Line 254), which searches between it's two input wavelengths 
for the tallest point, then returns that point along with it's voltage.  Right now, the inputs are just a span of 60 nm,
but one could change it to take in successive entries in the troughs array.  I had it set up to do this earlier, and
this code may still be available for you to view in TranslateText (the one without the 2), but it seemed to miss some
peaks for some reason.  Thus, I just made it do every 60 nm, incrementing by 5 nm in the hopes that we would miss nothing,
but maybe pick up some stuff we didn't want.

UnkTable is something I found to be needed because of the limits of the experiment.  It essentially allows you to exclude
anything that is too close to another peak so that it is not printed.  To control how much is excluded, edit Line 194,
in the first condition statement.  The idea here is that if you have a peak that has a peak at 768.5, 768.7, and 770 nm,
you do not want all of these peaks printed on top of eachother, clearly you just want the tallest one, so UnkTable lets
you exclude things that are too close.  Smarter code might average these values but I did not have time.

Line 201 might be of interest, since it calculates the cutoff that prevents any peak below it from being printed, so if you
want lower peaks printed, just change the multiplier on averageV in that line.

Lines 202 through 205 just filter out any maximum smaller than the cutoff voltage.

Lines 209 through 252 should not need editing, they just control the printing of the maxima labels and lines, as well as
averageV and cutoffV.

Line 248 will require adjustment, much like Line 93, since it determines the Image filename that it will be saved as.

EXTREMELY IMPORTANT!
A small note about arrays peaks, troughs, sortM, max, and maxima.  They all index in a fashion that I prefer so that I do 
not need 2 arrays for every single type of value.  Since every peak and trough, and generally every point of data collected 
consists of two points, one might want two arrays for everything.  But this is not neccessary at all!  If we just index the
arrays such that the X data (wavelength) is on an EVEN index and the Y data (voltage) is on an ODD index, than we can store
2D data in a 1D array.  This means that the first peak you find will have it's wavelength stored in index 0, while the second
peak will have it's wavelength store in index 2.  The voltage of the first peak will be at index 1, and for the second peak,
at index 2.  This means that iteration through these arrays can be confusing, since a for loop looking through their wavelengths
needs to increase it's iterator by 2 every time (i+=2 instead of i++ as you might usually write).  Keep this in mind if you
edit code regarding these arrays.