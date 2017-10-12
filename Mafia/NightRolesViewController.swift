//
//  NightRolesViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 11.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class NightRolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var actionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var playersTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dayNightButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var itemDayNightToolbar: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    // MARK: - События контроллера

    override func viewDidLoad() {
        super.viewDidLoad()

        // Настраиваем кнопку меню
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }

    override func viewDidLayoutSubviews(){
        actionTableHeight.constant = actionTableView.contentSize.height
        playersTableHeight.constant = playersTableView.contentSize.height
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Методы управления таблицей участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "PlayTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "test"
        
        return cell
    }
    
    // Определяем возможность редактировать таблицу участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
