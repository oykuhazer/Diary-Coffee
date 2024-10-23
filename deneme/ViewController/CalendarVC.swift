//
//  CoffeeDiaryViewController.swift
//  deneme
//
//  Created by Öykü Hazer Ekinci on 1.10.2024.
//


import UIKit

class CalendarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    let openPopupButton = UIButton()
  
    let calendarHeaderView = CalendarHeaderView()
    let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    var diaryEntries: [AniListesi] = []
    var filteredEntries: [AniListesi] = []
    var collectionView: UICollectionView!

    var selectedMonth = "Ekim"
    var selectedYear = 2024
    let pickerContainerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

     
        setupButton()
        setupCalendarHeader()
        setupCollectionView()
        setupPickerContainerView()

      
        fetchAniKayitlari(userId: "oyku", eventId: "a")
        
    }

    func fetchAniKayitlari(userId: String, eventId: String) {
           AniKayitlariGosterRequest.shared.fetchAniKayitlari(userId: userId, eventId: eventId) { [weak self] result in
               switch result {
               case .success(let response):
                   // API'den gelen veriyi alıyoruz
                   self?.diaryEntries = response.aniListesi
                   self?.collectionView.reloadData()
               case .failure(let error):
                   print("API Hatası: \(error.localizedDescription)")
               }
           }
       }
    
    func setupCalendarHeader() {
           calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(calendarHeaderView)

        calendarHeaderView.onDaySelected = { [weak self] selectedDay in
                   guard let self = self else { return }
                   self.filterDiaryEntries(for: selectedDay)
               }

        
           NSLayoutConstraint.activate([
               calendarHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
               calendarHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               calendarHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               calendarHeaderView.heightAnchor.constraint(equalToConstant: 300)
           ])

           // Month button action
           calendarHeaderView.monthButton.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
       }
    
    func filterDiaryEntries(for selectedDay: String) {
        // Gün formatını iki basamaklı yapalım
        let dayString = selectedDay.count == 1 ? "0\(selectedDay)" : selectedDay

        let monthIndex = months.firstIndex(of: selectedMonth)! + 1
        let formattedMonth = String(format: "%02d", monthIndex) // Ayı iki basamaklı formatla
        
        // Seçilen gün, ay ve yıla göre filtreleme
        let selectedDate = "\(selectedYear)-\(formattedMonth)-\(dayString)"
        
        print("Seçilen Tarih: \(selectedDate)")  // Tarihi kontrol edelim

        // EventDate'i kontrol edelim ve eşleşen girişleri bulalım
        filteredEntries = diaryEntries.filter { entry in
            print("Giriş Tarihi: \(entry.eventDate)")  // Giriş tarihini kontrol edelim
            return entry.eventDate == selectedDate
        }

        print("Filtrelenmiş Kayıt Sayısı: \(filteredEntries.count)") // Filtre sonrası sonucu kontrol edelim
        
        collectionView.reloadData()
    }
    func setupPickerContainerView() {
        // Picker container view ayarları
        let screenWidth = UIScreen.main.bounds.width * 0.96
        let alertViewX = (UIScreen.main.bounds.width - screenWidth) / 2
        pickerContainerView.frame = CGRect(x: alertViewX, y: UIScreen.main.bounds.height - 300, width: screenWidth, height: 270)
        
        pickerContainerView.backgroundColor = UIColor(red: 232/255, green: 226/255, blue: 213/255, alpha: 1) // Sakin bej kahve
        pickerContainerView.layer.cornerRadius = 20
        pickerContainerView.clipsToBounds = true
        pickerContainerView.isHidden = true
        view.addSubview(pickerContainerView)

        // Başlık görünümü
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        titleLabel.text = "Ay ve Yıl Seçimi"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = UIColor(red: 115/255, green: 104/255, blue: 94/255, alpha: 1)
        titleLabel.textAlignment = .center
        pickerContainerView.addSubview(titleLabel)

        // Ayraç çizgiler
        let separatorTop = UIView(frame: CGRect(x: 0, y: 59, width: screenWidth, height: 1))
        separatorTop.backgroundColor = UIColor(red: 200/255, green: 190/255, blue: 180/255, alpha: 0.7)
        pickerContainerView.addSubview(separatorTop)

        let separatorBottom = UIView(frame: CGRect(x: 0, y: 180, width: screenWidth, height: 1))
        separatorBottom.backgroundColor = UIColor(red: 200/255, green: 190/255, blue: 180/255, alpha: 0.7)
        pickerContainerView.addSubview(separatorBottom)

        // PickerView
        pickerView.frame = CGRect(x: 0, y: 60, width: screenWidth, height: 120)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 245/255, green: 240/255, blue: 230/255, alpha: 1)
        pickerContainerView.addSubview(pickerView)

        // Onayla butonu
        let confirmButton = UIButton(type: .system)
        confirmButton.frame = CGRect(x: screenWidth / 2 - 150, y: 200, width: 130, height: 44)
        confirmButton.setTitle("✓ ONAYLA", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)

        let confirmGradient = CAGradientLayer()
        confirmGradient.colors = [UIColor(red: 160/255, green: 120/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 139/255, green: 105/255, blue: 85/255, alpha: 1).cgColor]
        confirmGradient.frame = confirmButton.bounds
        confirmGradient.cornerRadius = 22
        confirmButton.layer.insertSublayer(confirmGradient, at: 0)
        confirmButton.layer.cornerRadius = 22
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        pickerContainerView.addSubview(confirmButton)

        // Vazgeç butonu
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: screenWidth / 2 + 20, y: 200, width: 130, height: 44)
        cancelButton.setTitle("✕ VAZGEÇ", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)

        let cancelGradient = CAGradientLayer()
        cancelGradient.colors = [UIColor(red: 177/255, green: 144/255, blue: 127/255, alpha: 1).cgColor, UIColor(red: 160/255, green: 110/255, blue: 90/255, alpha: 1).cgColor]
        cancelGradient.frame = cancelButton.bounds
        cancelGradient.cornerRadius = 22
        cancelButton.layer.insertSublayer(cancelGradient, at: 0)
        cancelButton.layer.cornerRadius = 22
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(closePickerView), for: .touchUpInside)
        pickerContainerView.addSubview(cancelButton)
    }

    @objc func showPickerView() {
        pickerContainerView.isHidden = false
        pickerContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        pickerContainerView.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.pickerContainerView.alpha = 1
            self.pickerContainerView.transform = .identity
        }
    }

    @objc func closePickerView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerContainerView.alpha = 0
            self.pickerContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            self.pickerContainerView.isHidden = true
        }
    }

    @objc func selectDate() {
        closePickerView()
        calendarHeaderView.monthButton.setTitle("\(selectedMonth) \(selectedYear)", for: .normal)
        let monthIndex = months.firstIndex(of: selectedMonth)! + 1
        calendarHeaderView.updateCalendar(for: monthIndex, year: selectedYear)
    }
    
    

    // UIPickerViewDataSource ve Delegate metotları
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Aylar ve Yıllar
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : 50 // Yıllar 50 yıl geriye
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : String(2024 - row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMonth = months[row]
        } else {
            selectedYear = 2024 - row
        }
    }


    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 250)
        layout.minimumLineSpacing = 50

       
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiaryEntryCell.self, forCellWithReuseIdentifier: "DiaryEntryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: openPopupButton.topAnchor, constant: -20)
        ])
    }

    func setupButton() {
        openPopupButton.setTitle("Anı Ekle", for: .normal)
        openPopupButton.backgroundColor = .systemBlue
        openPopupButton.layer.cornerRadius = 8
        openPopupButton.addTarget(self, action: #selector(openPopup), for: .touchUpInside)
        openPopupButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(openPopupButton)

        NSLayoutConstraint.activate([
            openPopupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPopupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            openPopupButton.widthAnchor.constraint(equalToConstant: 150),
            openPopupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func openPopup() {
        let coffeeDiaryEntryVC = DiaryEntryVC()

        // Seçilen gün, ay ve yıl bilgilerini alıyoruz
        if let selectedDate = calendarHeaderView.getSelectedDate(month: selectedMonth, year: selectedYear) {
            coffeeDiaryEntryVC.selectedDate = selectedDate
        } else {
            // Eğer gün seçilmediyse, şu anki tarihi kullan
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd" // Gün
            let currentDay = dateFormatter.string(from: Date()) // Şu anki gün

            let monthIndex = months.firstIndex(of: selectedMonth)! + 1 // Ayın sayısal değerini al
            let formattedMonth = String(format: "%02d", monthIndex) // Ayı iki basamaklı formatla
            let formattedDate = "\(currentDay)/\(formattedMonth)/\(selectedYear)" // Formatla
            coffeeDiaryEntryVC.selectedDate = formattedDate
        }

        navigationController?.pushViewController(coffeeDiaryEntryVC, animated: true)
    }


    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return filteredEntries.count
      }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryEntryCell", for: indexPath) as! DiaryEntryCell
          cell.configure(with: filteredEntries[indexPath.item])
          return cell
      }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 230)
    }
}


