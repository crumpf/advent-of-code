//
//  FileInput.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/3/20.
//

import Foundation

struct FileInput {
  let lines: [String]
  
  init?(pathRelativeToCurrentDirectory: String) {
    let fileURL = URL(fileURLWithPath: pathRelativeToCurrentDirectory, relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
    do {
      lines = try String(contentsOf: fileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    } catch {
      return nil
    }
  }
}
