import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(MyGreatApp());
}

class MyGreatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('File Handling Example'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Test data
                  final myList = ["Hello, World!", "Dart is fun", "File handling"];

                  // Write the list of strings to a file
                  writeToFile('my_file.txt', myList);
                },
                child: Text('Write to File'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Process file data: reverse each line and write to a new file
                  processFileData();
                },
                child: Text('Process File Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Writes a list of strings to a file and triggers auto-download.
  /// 
  /// Parameters:
  /// - [filename]: The name of the file to save.
  /// - [data]: The list of strings to write to the file.
  void writeToFile(String filename, List<String> data) {
    try {
      final blob = html.Blob([data.join('\n')], 'text/plain', 'native');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchorElement = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
      print('Data written to $filename successfully.');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }

  /// Reads the contents of a file and returns them as a list of strings.
  /// 
  /// Returns:
  /// A [Future] that completes with a list of strings read from the file.
  Future<List<String>> readFromFile() async {
    try {
      final input = html.FileUploadInputElement();
      input.accept = '.txt';
      input.click();

      await input.onChange.first;
      final files = input.files;
      if (files == null || files.isEmpty) {
        throw 'No file selected';
      }

      final file = files.first;
      final reader = html.FileReader();
      reader.readAsText(file);

      await reader.onLoad.first;
      final result = reader.result;
      if (result is String) {
        return result.split('\n');
      } else {
        throw 'File reading error';
      }
    } catch (e) {
      print('Error reading from file: $e');
      return [];
    }
  }

  /// Reads from an input file, reverses each line, and writes the reversed lines to an output file.
  /// 
  /// This function uses the file input element to read the input data and writes the processed
  /// data to the output file.
  void processFileData() async {
    try {
      final inputData = await readFromFile();
      final reversedData = inputData.map((line) => line.split('').reversed.join('')).toList();
      writeToFile('output_file.txt', reversedData);
    } catch (e) {
      print('Error processing file data: $e');
    }
  }
}
