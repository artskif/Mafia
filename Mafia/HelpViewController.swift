//
//  HelpViewController.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 30.10.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Элементы управления контроллера
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var helpTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar_bg_dark"), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Метод вызываемый непосредственно перед навигацией по контроллерам
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // обработка поведения нового контроллера в зависимости от того каким переходом(segue) мы пользуемся
        switch(segue.identifier ?? "") {
        case "ShowArticle":
            guard let сhooseArticleViewController = segue.destination as? HelpArticleViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            if let selectedIndexPath = helpTableView.indexPathForSelectedRow {
                let selectedHelp = HelpArticles(rawValue: selectedIndexPath.section)
                сhooseArticleViewController.choosedHelp = selectedHelp!
            }
        default:
            break
        }
    }
    // MARK: - Методы инициализации таблицы выбора участников
    
    // Кличесто элементов в одной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        // У нас в таблице роли пользователя
        return HelpArticles.count
    }
    
    // Расстояние между ячейками(секциями)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Описываем состояние заголовка секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Ничего не делаем
    }
    
    // Обрабатываем внешний вид и содержимое каждой ячейки таблицы выбора поочередно
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRoleIdentifer = "HelpTableViewCell"
        
        
        // В данном варианте мы выбираем роли,
        // следовательно должны показать роли для возможности сменить роль(выбранного персонажа)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellRoleIdentifer, for: indexPath) as? HelpTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HelpTableViewCell.")
        }
        
        let currentHelp = HelpArticles(rawValue: indexPath.section)!
        
        // Данные ячейки
        cell.title.text = currentHelp.title
        
        return cell
    }
    
    // Определяем возможность редактировать таблицу выбора участников
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
