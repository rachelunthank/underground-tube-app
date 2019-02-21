//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit
import WebKit

class MapViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tflTubeMap = URL(string: "https://tfl.gov.uk/cdn/static/cms/images/tube-map.gif")

        guard let mapUrl = tflTubeMap else {
            return
        }

        let tubeMapUrlRequest = URLRequest(url: mapUrl)
        webView?.load(tubeMapUrlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

