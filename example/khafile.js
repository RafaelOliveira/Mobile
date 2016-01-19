var project = new Project('Example');

project.addAssets('Assets/**');
project.addSources('Sources');
project.addSources('../lib');

project.windowOptions.width = 480;
project.windowOptions.height = 720;

return project;