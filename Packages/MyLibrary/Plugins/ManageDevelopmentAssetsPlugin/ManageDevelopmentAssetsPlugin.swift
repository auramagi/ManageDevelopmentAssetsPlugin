//
//  ManageDevelopmentAssetsPlugin.swift
//
//
//  Created by Mikhail Apurin on 2023/09/08.
//

import Foundation
import PackagePlugin
import XcodeProjectPlugin

@main
struct ManageDevelopmentAssetsPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let directory = URL(filePath: target.directory.string)

        // Copy all NAME.development.xcassets -> NAME.xcassets

        let xcassets = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "xcassets" }
            .filter { $0.deletingPathExtension().pathExtension == "development" }
            .map {
                try copyAssets(
                    context: context,
                    input: Path($0),
                    output: context.pluginWorkDirectory
                        .appending(
                            $0.deletingPathExtension()
                                .deletingPathExtension()
                                .appendingPathExtension("xcassets")
                                .lastPathComponent
                        )
                )
            }

        // Copy all FOLDERNAME.development -> FOLDERNAME

        let resources = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.isDirectoryKey])
            .filter { try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true }
            .filter { $0.pathExtension == "development" }
            .map {
                try copyAssets(
                    context: context,
                    input: Path($0),
                    output: context.pluginWorkDirectory
                        .appending(
                            $0.deletingPathExtension()
                                .lastPathComponent
                        )
                )
            }

        return xcassets + resources
    }

    func copyAssets(context: PluginContext, input: Path, output: Path) throws -> Command {
        let script = context.package.directory.appending(["Plugins", "ManageDevelopmentAssetsPlugin", "copy_assets.sh"])

        return try .buildCommand(
            displayName: "Manage development assets: \(output.lastComponent)",
            executable: context.tool(named: "zsh").path,
            arguments: [
                script,
                "-i",
                input,
                "-o",
                output,
            ],
            inputFiles: [script, input],
            outputFiles: [output]
        )
    }
}

extension Path {
    init(_ url: URL) {
        self.init(url.path(percentEncoded: false))
    }
}
