import UIKit

class RedViewController: UIViewController {
    // UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Erişilebilirlik"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkboxContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkboxLabel: UILabel = {
        let label = UILabel()
        label.text = "Okudum, onaylıyorum."
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCheckBoxLabelTap)))
        return label
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Checkbox değeri \(false)"
        button.accessibilityIdentifier = "checkboxButton"
        return button;
    }()
    
    private var isChecked = false
    
    private func updateCheckboxImage() {
        if #available(iOS 13.0, *) {
            let imageName = isChecked ? "checkmark.square" : "square"
            let image = UIImage(systemName: imageName)
            checkboxButton.setImage(image, for: .normal)
            if image == nil {
                print("SF Symbol image '\(imageName)' not found!")
                checkboxButton.setTitle(isChecked ? "✓" : "", for: .normal)
            } else {
                checkboxButton.setTitle("", for: .normal)
            }
        }
    }
    
    @objc private func checkboxTapped() {
        isChecked.toggle()
        checkboxButton.accessibilityLabel = "Check değeri \(isChecked)"
        updateCheckboxImage()
    }
    
    private let hesaplarLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesaplar"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func hesaplarLabelTapped() {
        print("Hesaplar label tapped")
    }
    
    @objc private func onCheckBoxLabelTap() {
        checkboxTapped()
    }
    
    private let hesaplarImageView: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "star")
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc private func imageViewTapped() {
        hesaplarLabel.isHidden.toggle()
    }
    
    private let attributedContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tappableLabel: UILabel = {
        let label = UILabel()
        let fullText = "Bu aydınlatma metninden sadece bu kırmızı yazıya tıklanabilir."
        let attributedString = NSMutableAttributedString(string: fullText)
        let redText = "bu kırmızı yazıya"
        if let redRange = fullText.range(of: redText) {
            let nsRange = NSRange(redRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
        }
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    @objc private func tappableLabelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        let text = label.attributedText?.string ?? ""
        let tapLocation = gesture.location(in: label)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString())
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        // Sadece 'bu kırmızı yazıya' kısmına tıklanınca border kırmızı olacak
        let fullText = text
        let redText = "bu kırmızı yazıya"
        let nsRange = (fullText as NSString).range(of: redText)
        print("Tap index: \(index), RedText range: \(nsRange)")
        if nsRange.location != NSNotFound {
            if index >= nsRange.location && index < nsRange.location + nsRange.length {
                attributedContainer.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableData: [String] = ["Birinci", "İkinci", "Üçüncü"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Title label
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Checkbox container
        view.addSubview(checkboxContainer)
        checkboxContainer.addSubview(checkboxLabel)
        checkboxContainer.addSubview(checkboxButton)
        
        // Checkbox action
        updateCheckboxImage()
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        // Add Hesaplar label
        view.addSubview(hesaplarLabel)
        let hesaplarTap = UITapGestureRecognizer(target: self, action: #selector(hesaplarLabelTapped))
        hesaplarLabel.isUserInteractionEnabled = true
        hesaplarLabel.addGestureRecognizer(hesaplarTap)
        
        // Add image view to the right of the label
        view.addSubview(hesaplarImageView)
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        hesaplarImageView.addGestureRecognizer(imageTap)
        
        // Add attributed container and label
        view.addSubview(attributedContainer)
        attributedContainer.addSubview(tappableLabel)
        let tappableTap = UITapGestureRecognizer(target: self, action: #selector(tappableLabelTapped(_:)))
        tappableLabel.addGestureRecognizer(tappableTap)
        
        // Add table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SwipeableCell.self, forCellReuseIdentifier: "SwipeableCell")
        
        // Layout
        NSLayoutConstraint.activate([
            checkboxContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            checkboxContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkboxContainer.heightAnchor.constraint(equalToConstant: 40),
            
            checkboxLabel.leadingAnchor.constraint(equalTo: checkboxContainer.leadingAnchor),
            checkboxLabel.centerYAnchor.constraint(equalTo: checkboxContainer.centerYAnchor),
            
            checkboxButton.leadingAnchor.constraint(equalTo: checkboxLabel.trailingAnchor, constant: 12),
            checkboxButton.trailingAnchor.constraint(equalTo: checkboxContainer.trailingAnchor),
            checkboxButton.centerYAnchor.constraint(equalTo: checkboxContainer.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 28),
            checkboxButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Hesaplar label constraints
            hesaplarLabel.topAnchor.constraint(equalTo: checkboxContainer.bottomAnchor, constant: 32),
            hesaplarLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            
            // ImageView constraints
            hesaplarImageView.centerYAnchor.constraint(equalTo: hesaplarLabel.centerYAnchor),
            hesaplarImageView.leadingAnchor.constraint(equalTo: hesaplarLabel.trailingAnchor, constant: 16),
            hesaplarImageView.widthAnchor.constraint(equalToConstant: 32),
            hesaplarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Attributed container constraints
            attributedContainer.topAnchor.constraint(equalTo: hesaplarLabel.bottomAnchor, constant: 40),
            attributedContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attributedContainer.widthAnchor.constraint(equalToConstant: 320),
            attributedContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            // Tappable label constraints (with horizontal padding)
            tappableLabel.topAnchor.constraint(equalTo: attributedContainer.topAnchor, constant: 8),
            tappableLabel.bottomAnchor.constraint(equalTo: attributedContainer.bottomAnchor, constant: -8),
            tappableLabel.leadingAnchor.constraint(equalTo: attributedContainer.leadingAnchor, constant: 12),
            tappableLabel.trailingAnchor.constraint(equalTo: attributedContainer.trailingAnchor, constant: -12),
            
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: attributedContainer.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableView DataSource & Delegate

extension RedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableCell", for: indexPath) as? SwipeableCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    // Swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completionHandler) in
            self?.tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { (_, _, completionHandler) in
            // Düzenle işlemi burada yapılabilir
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }
} 
