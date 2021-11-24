import UIKit

/// Define each profile screen case
enum ProfileScreen {
    case moments, saved, history
    
    /// Return descriptive symbol for each `ProfileScreen`
    func getImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        
        switch self {
        case .moments:
            return UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: config)
        case .saved:
            return UIImage(systemName: "bookmark", withConfiguration: config)
        case .history:
            return UIImage(systemName: "clock.arrow.circlepath", withConfiguration: config)
        }
    }
    
    /// Return descriptive text for each `ProfileScreen`
    func getText() -> String {
        switch self {
        case .moments:
            return "Você ainda não tirou nenhuma foto"
        case .saved:
            return "Você ainda não salvou nenhuma brincadeira"
        case .history:
            return "Você ainda não visualizou nenhuma brincadeira"
        }
    }
}

protocol EmptyView: UIView {
    func setBackgroundView(_ view: UIView)
}

// Accepted UIViews so far: UITableView and UICollectionView
extension UITableView: EmptyView {
    func setBackgroundView(_ view: UIView) {
        backgroundView = view
    }
}

extension UICollectionView: EmptyView {
    func setBackgroundView(_ view: UIView) {
        backgroundView = view
    }
}

/// Utility that present a empty message in profile's views that can be empty
class EmptyViewHandler {

    // MARK: - Parameters

    private static let spacing: CGFloat = 8
    private static let color: UIColor = .systemGray2
    
    // MARK: - Functions

    private static func createBackgroundView(screen: ProfileScreen, frame: CGRect) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = self.spacing
        stack.alignment = .center
        
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = screen.getText()
        label.textColor = self.color

        let imageView = UIImageView()
        imageView.image = screen.getImage()
        imageView.tintColor = self.color
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        let bgView = UIView(frame: frame)
        bgView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let hConstraint = stack.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        let vConstraint = stack.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        bgView.addConstraints([hConstraint, vConstraint])
        
        return bgView
    }
    
    // MARK: - Methods

    static func setEmptyView(for screen: ProfileScreen, in parentView: EmptyView) {
        let bgView = createBackgroundView(screen: screen, frame: parentView.frame)
        
        parentView.setBackgroundView(bgView)
    }
}
