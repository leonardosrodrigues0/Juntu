//
//  CameraViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 20/09/21.
//

import UIKit

/// Allow a UIViewController to use the camera.
protocol CameraManager: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    
    func takePicture()
}

extension CameraManager {
    
    /// Default implementation for a simple camera usage.
    func takePicture() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    /// Share an image with a Juntu watermark and an associated text.
    /// Built to be called inside `imagePickerController` method at the UIViewController.
    func shareImageAndText(didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any], text: String) {
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found while unwrapping ImagePicker info")
            return
        }
        
        guard let juntuImage = UIImage(named: "juntuWatermark") else {
            print("Error: failed to load Juntu image.")
            return
        }
        
        let watermarkedImage = addWatermark(image: image, watermarkImage: juntuImage, proportion: 0.3)
        // here you add image to filesystem
        saveOnFileSystem(image: watermarkedImage)
        shareImageAndText(image: watermarkedImage, text: text)
    }
    
    /// Add a watermark to an image. The proportion is used as a ratio between the largest mark dimension and the smallest image dimension.
    private func addWatermark(image: UIImage, watermarkImage: UIImage, proportion: CGFloat) -> UIImage {
        // Draw image
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(
            width: image.size.width,
            height: image.size.height
        ))

        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        // Draw watermark image
        let scaleFactor = calculateScaleFactor(imageSize: image.size, markSize: watermarkImage.size, proportion: proportion)
        let watermarkRect = CGRect(origin: CGPoint.zero, size: CGSize(
            width: scaleFactor * watermarkImage.size.width,
            height: scaleFactor * watermarkImage.size.height
        ))
        
        watermarkImage.draw(in: watermarkRect)

        // Get result.
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    /// Calculates the scale factor for watermark image.
    /// - Parameters:
    ///   - imageSize: Image size.
    ///   - markSize: Watermark image original size.
    ///   - markSize: Watermark image proportion to the image size.
    /// - Returns: Scale factor to reduce watermark image.
    private func calculateScaleFactor(imageSize: CGSize, markSize: CGSize, proportion: CGFloat) -> CGFloat {
        let smallImageDimension = min(imageSize.width, imageSize.height)
        let largeMarkDimension = max(markSize.width, markSize.height)
        let wantedMarkDimension = smallImageDimension * proportion
        return wantedMarkDimension / largeMarkDimension
    }
    
    private func shareImageAndText(image: UIImage, text: String) {
        // Set up activity view controller
        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: text)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // Present the share view controller
        present(activityViewController, animated: true)
    }
    
    // lógica para salvar imagens tiradas na pasta de pictures dentro de documents
    private func saveOnFileSystem(image: UIImage) {
        
        let fm = FileManager.default
        let picturesFolder: URL = getDocumentsDirectory().appendingPathComponent("pictures")
        var isdirectory: ObjCBool = true
        
        /// esse trecho checa se existe a pasta
        /// se existir, a funcao salva a imagem direto
        /// se nao existir, a funcao cria o novo diretorio e salva a imagem
        if fm.fileExists(atPath: picturesFolder.path, isDirectory: &isdirectory) {
            if isdirectory.boolValue {
                /// file exists and is a directory
                saveImage(image: image, picturesFolder: picturesFolder)
            }
        } else {
            /// directory does not exist
            do {
                try fm.createDirectory(at: picturesFolder, withIntermediateDirectories: false, attributes: nil)
                saveImage(image: image, picturesFolder: picturesFolder)
            } catch {
                print("Unable to create new directory to Disk: \(error)")
            }
        }

    }
    
    // funcao simples que retorna a URL da pasta de documents do app
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // salva a imagem recebida como parametro no endereco recebido como parametro
    private func saveImage(image: UIImage, picturesFolder: URL) {
        if let data = image.pngData() {
            let filePath = picturesFolder.appendingPathComponent("\(Date()).png")
            do {
                try data.write(to: filePath)
                print("Imagesaved")
            } catch {
                print("Unable to Write Data to Disk \(error)")
            }
        }
    }
}
