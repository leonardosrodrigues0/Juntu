import Foundation
import UIKit

/// Utility that present a loading indicator in views that require Internet requests.
class LoadingHandler {
    
    // MARK: - Properties
    
    private var parentView: UIView
    private weak var activityIndicator: UIActivityIndicatorView!
    private weak var label: UILabel!
    
    // MARK: - Initializers
    
    /// Present the loading indicator in the parent view. Call this initializer before Internet request
    public init(parentView: UIView) {
        self.parentView = parentView
        
        (self.activityIndicator, self.label) = createIndicatorView(parentView: parentView)
        
        start()
    }
    
    // MARK: - Methods
    
    private func createIndicatorView(parentView view: UIView) -> (indicator: UIActivityIndicatorView, label: UILabel) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Carregando".uppercased()
        
        stack.addArrangedSubview(activityIndicator)
        stack.addArrangedSubview(label)
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let hConstraint = stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let vConstraint = stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        view.addConstraints([hConstraint, vConstraint])
        
        return (activityIndicator, label)
    }
    
    private func start() {
        activityIndicator?.startAnimating()
    }
    
    /// Hide the loading indicator. Called when Internet request returns
    public func stop() {
        activityIndicator?.stopAnimating()
        label.isHidden = true
    }
}
