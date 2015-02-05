PImage img;
ArrayList<Text> texts = new ArrayList<Text>();
ArrayList<Image> images = new ArrayList<Image>();
int margin = 0;
String path, images_dir_path;

void setup() {
  path = sketchPath;
  images_dir_path = path + "/img";
  String[] filenames = findImgFiles(listFileNames(images_dir_path));
  println(filenames);
  
  size(1024, 768);
  // Create the font
  textFont(createFont("Georgia", 36));
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  texts.add(new Text("När Bohuslän tillhörde Norge och Halland tillhörde Danmark var Göta älv Sveriges väg väster ut i Europa för varor och krigsskepp. Vid älven behövs en stad. Först byggs Gamla Lödöse vid Lilla Edet. Sedan kom Nya Lödöse, där stadsdelen Gamlestan ligger i dag.", new PVector(width/2, height/2), 14));
  texts.add(new Text("Fire", new PVector(50, 50), 14));

  for (int i = 0; i < filenames.length; i++) {
    //loadImage("/img/"+filenames[i]);
    images.add(new Image("img/"+filenames[i], new PVector(random(1024), random(200))));
  }

  strokeWeight(100);
  stroke(0, 0, 255);
  noFill();
  
}

int count = 0;

void draw() {
  background(255);


  // Displays the image at its actual size at point (0,0)
  //image(img, 0, 0);
  // Displays the image at point (0, height/2) at half of its size
  //image(img, 0, height/2, img.width/2, img.height/2);

  for (Image im : images)
  {
    image(im.img, im.location.x, im.location.y, width-im.location.x, im.img.width/im.img.height * (width-im.location.x));

    im.location.x += im.direction.x;
    im.location.y += im.direction.y;

    if (im.location.x < 0 - margin)
      im.location.x = width + margin;
    if (im.location.x > width + margin)
      im.location.x = 0 - margin;
    if (im.location.y < 0 - margin)
      im.location.y = height + margin;
    if (im.location.y > height + margin)
      im.location.y = 0 - margin;
  }

  for (Text t : texts)
  {
    textSize(t.size);
    fill(0);
    text(t.text, t.location.x, t.location.y);

    t.location.x += t.direction.x;
    t.location.y += t.direction.y;

    if (t.location.x < 0 - margin)
      t.location.x = width + margin;
    if (t.location.x > width + margin)
      t.location.x = 0 - margin;
    if (t.location.y < 0 - margin)
      t.location.y = height + margin;
    if (t.location.y > height + margin)
      t.location.y = 0 - margin;
  }
  
  text(count, 10, 10);
  text(frameRate, 10, 30);
  count++;
  count = count % 360;
}

class Image
{
  PVector location;
  PVector size;
  PVector direction;
  PImage img;

  Image(String filename, PVector startLocation)
  {
    println("Loading image: "+filename);
    img = loadImage(filename);
    location = startLocation;
    float angle = random(TWO_PI);
    angle = 0;
    direction = new PVector(cos(angle), sin(angle));
  }
}

class Text
{
  String text;
  PVector location;
  int size;
  PVector direction;

  Text(String string, PVector startLocation, int startSize)
  {
    text = string;
    location = startLocation;
    size = startSize;
    float angle = random(TWO_PI);
    direction = new PVector(cos(angle), sin(angle));
  }
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

String[] findImgFiles( String[] filenames ) {
// http://computationalphoto.mlog.taik.fi/2011/03/05/processing-finding-images-in-a-directory-listing/

  // this is where we'll put the found image files
  String[] outList_of_foundImageFiles = {
  };

  // to find out what a valid image file suffic might be
  String[] list_of_imageFileSuffixes = {
    "jpeg", "jpg", "tif", "tiff", "png"
  };

  if( images_dir_path.charAt( images_dir_path.length() -1 ) == '/' ) {
    println(" looks like there's a slash at the end of the dir path… no need for modifications ");
  }
  else {
    images_dir_path = images_dir_path+'/' ;
    println(" aha! it's missing a slash at the end, let's add one. \n\t images_dir_path is now = "+images_dir_path );
  }

  // ____ go through all the filenames
  // and check whether the fileending is not one for images
  for( int file_i = 0; file_i < filenames.length ; file_i++ ) {

    println(" looking at file "+filenames[file_i]+" checking if it might not just be a image file ");

    String[] curr_filenameSplit = splitTokens( filenames[ file_i], "." );

    // ___ now check whether file suffix matches any in
    // our little list of filesuffixes
    for( int fileSuffix_i = 0 ; fileSuffix_i < list_of_imageFileSuffixes.length ; fileSuffix_i++ ) { // only do this is the file has a suffix!! // (i.e. which it hopefully has if a split string results // in more than one part/length ) if( curr_filenameSplit.length > 1 ) {
      // fetch the filesuffixes as strings
      // (this might be a long-winded way of doing it,
      // but it takes out some the common instances of bugs… )
      String examinedFile_filesuffix = curr_filenameSplit[curr_filenameSplit.length-1] ;
      String listOfValid_fileSuffixed = list_of_imageFileSuffixes[fileSuffix_i] ;

      // do the actual comparison
      if( examinedFile_filesuffix.equals( listOfValid_fileSuffixed ) ) {
        // and if it's a matching image file suffix, add the whole
        // filepath to the file to the list out outfilenames
        outList_of_foundImageFiles = append( outList_of_foundImageFiles,filenames[ file_i ] );
      }
    }
  }
  // and return something nice
  return outList_of_foundImageFiles;
}
