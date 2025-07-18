import UIKit

class SwipeableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Özelleştirme burada yapılabilir
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
} 