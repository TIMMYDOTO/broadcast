//
//  PDFViewController.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 19.03.2024.
//

import UIKit
import PDFKit
import SnapKit

class PDFViewController: UIViewController {

    
     var pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
    }
    
    func setupPDFView() {
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        if let path = Bundle.main.path(forResource: "Polytics", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
    }
}
