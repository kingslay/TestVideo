import Foundation

try createM3u()

func createM3u() throws {
    let path = FileManager.default.currentDirectoryPath
    let url = URL(filePath: path)
    let dirName = url.lastPathComponent
    let filenames = try FileManager.default.contentsOfDirectory(atPath: path)
    
    var data = "#EXTM3U"
    filenames.filter{ filename in
        if let typeID = try? url.appendingPathComponent(filename).resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier as CFString? {
            return UTTypeConformsTo(typeID, kUTTypeMovie) || UTTypeConformsTo(typeID, kUTTypeAudio)
        }
        return false
    }.forEach { filename in
        data += """
        
        #EXTINF:-1 group-title="github",\(filename)
        ./\(filename)
        """
    }
    FileManager.default.createFile(atPath: path + "/\(dirName).m3u", contents: data.data(using: .utf8), attributes: nil)
}
