//
//  CharacterDetailsViewController.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import UIKit
import Photos

final class CharacterViewController: UIViewController, UINavigationControllerDelegate {
    
    private var inputPersonageData: Personages
    
    private var characterProperties: [PairProperties]?
    
    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tableView = UITableView.init(frame: .zero, style: .plain)
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "camera")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(changePhotoAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto", size: 32)
        label.text = inputPersonageData.name
        label.textAlignment = .center
        return label
    }()
    
    private lazy var headlinerTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.00)
        label.text = "Informations:"
        return label
    }()
    
    init(inputPersonageData: Personages) {
        self.inputPersonageData = inputPersonageData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createCustomNavBar()
    }
    
    func setupUI() {
        characterProperties = [
               PairProperties(propertyType: "Gender", property: inputPersonageData.gender),
               PairProperties(propertyType: "Status", property: inputPersonageData.status),
               PairProperties(propertyType: "Specie", property: inputPersonageData.species),
               PairProperties(propertyType: "Origin", property: inputPersonageData.origin.name),
               PairProperties(propertyType: "Type", property: inputPersonageData.type),
               PairProperties(propertyType: "Location", property: inputPersonageData.location.name)
           ]
        
        view.backgroundColor = .white
        
        [tableView, characterImage, photoButton, nameLabel, headlinerTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.rowHeight = 55
        tableView.estimatedRowHeight = 100
        tableView.separatorColor = .gray
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)

        tableView.dataSource = self
        
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        
        guard let imageURL = URL(string: inputPersonageData.image) else { return }
        characterImage.load(url: imageURL)
        
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImage.heightAnchor.constraint(equalToConstant: 148),
            characterImage.widthAnchor.constraint(equalToConstant: 147),
            
            photoButton.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            photoButton.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 8),
            photoButton.heightAnchor.constraint(equalToConstant: 32),
            photoButton.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 40),
            nameLabel.heightAnchor.constraint(equalToConstant: 35),
            nameLabel.widthAnchor.constraint(equalToConstant: 314.6),
            
            headlinerTextLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            headlinerTextLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            headlinerTextLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headlinerTextLabel.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changePhotoAction() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chooseFromGalleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { action in
            self.showImagePicker(sourceType: .photoLibrary) }
        actionSheet.addAction(chooseFromGalleryAction)
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            self.showImagePicker(sourceType: .camera) }
        actionSheet.addAction(takePhotoAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characterProperties?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as? CharacterTableViewCell, let characterProperties = characterProperties else { return UITableViewCell() }
        cell.configure(data: characterProperties[indexPath.row])
        return cell
    }
}

extension CharacterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            characterImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
