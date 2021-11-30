import UIKit

/// Define each profile screen case
enum EmptyScreen {
    case moments, saved, history, search
    
    /// Return descriptive symbol for each `EmptyScreen`
    func getImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        
        switch self {
        case .moments:
            return UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: config)
        case .saved:
            return UIImage(systemName: "bookmark", withConfiguration: config)
        case .history:
            return UIImage(systemName: "clock.arrow.circlepath", withConfiguration: config)
        case .search:
            return UIImage(systemName: "magnifyingglass", withConfiguration: config)
        }
    }
    
    /// Return descriptive text for each `EmptyScreen`
    func getText() -> String {
        switch self {
        case .moments:
            return "Você ainda não tirou nenhuma foto"
        case .saved:
            return "Você ainda não salvou nenhuma brincadeira"
        case .history:
            return "Você ainda não visualizou nenhuma brincadeira"
        case .search:
            return "Nenhuma brincadeira encontrada"
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

    private static func createBackgroundView(screen: EmptyScreen, frame: CGRect) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = self.spacing
        stack.alignment = .center
        
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = screen.getText()
        label.textAlignment = .center
        label.textColor = self.color

        let imageView = UIImageView()
        imageView.image = screen.getImage()
        imageView.tintColor = self.color
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        let bgView = UIView(frame: frame)
        bgView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = stack.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16)
        let trailingConstraint = bgView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 16)
        let hConstraint = stack.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        let vConstraint = stack.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        bgView.addConstraints([leadingConstraint, trailingConstraint, hConstraint, vConstraint])
        
        return bgView
    }
    
    // MARK: - Methods

    static func setEmptyView(for screen: EmptyScreen, in parentView: EmptyView) {
        let bgView = createBackgroundView(screen: screen, frame: parentView.frame)
        
        parentView.setBackgroundView(bgView)
    }
}
