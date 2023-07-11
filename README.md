<h1>Skippyr's Cursor</h1>
	<h2>Starting Point</h2>
		<p>A 58x58 pixels custom cursor for X11 (aka Linux) with my GitHub avatar.</p>
		<p>Here is a quick preview.</p>
		<img src="./images/preview.png"/>
	<h2>Installation And Usage</h2>
		<h3>Installing From Releases (recommended)</h3>
			<p>By installing it this way, you do not have to build it. Follow these steps:</p>
			<ul>
				<li>Download the <code>skippyr_cursor.zip</code> file from the latest release.</li>
				<li>Unzip the file.</li>
				<li>Copy the <code>skippyr_cursor</code> directory extracted to <code>~/.local/share/icons</code>. You might need to create that directory first.</li>
					<p>After extracting, ensure that you are copying the directory containing the cursor files, as some system utilities that extract ZIP files might create an extra directory around the contents, which may cause the system to not recognize the cursor.</p>
			</ul>
		<h3>Building From Source</h3>
			<p>Follow these steps:</p>
			<ul>
				<li>Install the build dependencies:</li>
					<ul>
						<li>imagemagick (latest version)</li>
							<p>The latest version is required to build the PNG images from the source files.</p>
						<li>xcursorgen</li>
							<p>The X11 utility to create a cursor from PNG files.</p>
						<li>ruby</li>
							<p>The programming language used in the build script.</p>
						<li>git</li>
							<p>The utility to clone this repository.</p>
					</ul>
				<li>Clone this repository.</li>
					<pre><code>git clone --depth=1 https://github.com/skippyr/skippyr_cursor</code></pre>
				<li>Access the repository's directory.</li>
					<pre><code>cd skippyr_cursor</code></pre>
				<li>Run the build script.</li>
					<pre><code>ruby scripts/build.rb</code></pre>
					<p>This script will create the cursor and also the images and place them under the <code>distributions</code> directory:</p>
				<li>Install the cursor for your current user by copying it to <code>~/.local/share/icons</code>.</li>
					<pre><code>
mkdir -p ~/.local/share/icons
cp -r distributions/skippyr_cursor ~/.local/share/icons
					</code></pre>
			</ul>
	<h2>Issues And Suggestions</h2>
		<p>Report issues and suggestions through the <a href="https://github.com/skippyr/skippyr_cursor/issues">issues tab</a>.
	<h2>License</h2>
		<p>This project is released under terms of the MIT License.</p>
		<p>Copyright (c) 2023, Sherman Rofeman. MIT License.</p>

