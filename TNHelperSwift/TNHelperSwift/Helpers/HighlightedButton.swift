

import UIKit

class HighlightedButton: UIButton {

    @IBInspectable var sbReverseColor: Bool {
        didSet {
            if sbReverseColor {
                self.layer.borderWidth = 0.8
                self.layer.borderColor = UIColor.black.cgColor
                self.setTitleColor(UIColor.black, for: .normal)
                self.setTitleColor(UIColor.white, for: .highlighted)
                self.setTitleColor(UIColor.white, for: .selected)
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBInspectable var sbShadowBorder: Bool {
        didSet {
            if sbShadowBorder {
                self.layer.borderWidth = 0.0
               // self.layer.shadowColor = UIColor.black74?.cgColor
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowRadius = 10.0
                self.layer.shadowOpacity = 0.2
            }
        }
    }

    var reverseColor: Bool
    var shadowBorder: Bool
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    public override init(frame: CGRect) {
        self.reverseColor = false
        self.sbReverseColor = false
        self.shadowBorder = false
        self.sbShadowBorder = false
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.reverseColor = false
        self.sbReverseColor = false
        self.shadowBorder = false
        self.sbShadowBorder = false
        super.init(coder: aDecoder)
        setupButton()
    }
    
    public convenience init(frame: CGRect, reverse: Bool, shadow: Bool) {
        self.init(frame: frame)
        self.reverseColor = reverse
        self.sbReverseColor = false
        self.shadowBorder = shadow
        self.sbShadowBorder = false
        setupButton()
    }
    
    func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 0
       // titleLabel?.font = FontUtil().getBylineFont()
        titleLabel?.adjustsFontForContentSizeCategory = true
        if reverseColor {
            layer.borderWidth = 0.8
            layer.borderColor = UIColor.black.cgColor
            setTitleColor(UIColor.black, for: .normal)
            setTitleColor(UIColor.white, for: .highlighted)
            backgroundColor = UIColor.white
        } else {
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.black
        }
        
        if shadowBorder {
            self.layer.borderWidth = 0.0
           // self.layer.shadowColor = UIColor.black74?.cgColor
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 10.0
            self.layer.shadowOpacity = 0.2
        }
        self.contentEdgeInsets = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 50)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if reverseColor {
//                backgroundColor = isHighlighted ? UIColor.black : UIColor.white
//                layer.borderColor = isHighlighted ? UIColor.black74?.cgColor : UIColor.black.cgColor
//                setTitleColor(UIColor.black, for: .normal)
//                setTitleColor(UIColor.white, for: .highlighted)
            } else {
//                backgroundColor = isHighlighted ? UIColor.black74 : UIColor.black
//                setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
//            if reverseColor {
//                backgroundColor = isEnabled ? UIColor.black : UIColor.black40
//                layer.borderColor = isEnabled ? UIColor.black74?.cgColor : UIColor.black.cgColor
//                setTitleColor(UIColor.black, for: .normal)
//                setTitleColor(UIColor.white, for: .highlighted)
//            } else {
//                backgroundColor = isEnabled ? UIColor.black : UIColor.black40
//            }
        }
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        if activityIndicator == nil {
            return
        }
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
