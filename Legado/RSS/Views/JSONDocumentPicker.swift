import SwiftUI
import UniformTypeIdentifiers

/// 通用 JSON/文本文件选择器。
/// 用 UIKit 的 UIDocumentPickerViewController 而非 SwiftUI .fileImporter：
/// 后者在本工程主题化 NavigationStack + 多 sheet 挂载场景下（iOS 26/27）
/// 存在点选无响应的兼容问题；本地书籍导入走 UIKit 封装一直正常。
struct JSONDocumentPicker: UIViewControllerRepresentable {
    let onPick: (URL) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(
            forOpeningContentTypes: [.json, .plainText, .text],
            asCopy: true
        )
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        private let parent: JSONDocumentPicker

        init(parent: JSONDocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onCancel()
                return
            }
            parent.onPick(url)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onCancel()
        }
    }
}
