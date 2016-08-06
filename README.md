# Remove All Except Dot Git

 Remove all directories and files for a given path except those for Git.
 These include `.git` and `.gitignore`.
 
 This is useful for maintaining a repository that is dynamically generated
 such as with a Jekyll site.
 
 The use case is where you want to ensure that no previous files from a previous Jekyll build
 are lying around in your directory that you use for publishing your blog.
