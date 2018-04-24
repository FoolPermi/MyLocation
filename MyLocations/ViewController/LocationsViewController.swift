//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Permi on 2018/4/17.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {
  
  var managedObjectContext: NSManagedObjectContext!
  var locations = [Location]()
  lazy var fetchedResultController: NSFetchedResultsController<Location> = {
    let fetchRequest = NSFetchRequest<Location>()
    let entity = Location.entity()
    fetchRequest.entity = entity
    let sort1 = NSSortDescriptor(key: "category", ascending: true)
    let sort2 = NSSortDescriptor(key: "date", ascending: true)
    fetchRequest.sortDescriptors = [sort1, sort2]
    fetchRequest.fetchBatchSize = 20
    let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Locations")
    fetchResultController.delegate = self
    return fetchResultController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = editButtonItem
    NSFetchedResultsController<Location>.deleteCache(withName: "Locations")
    performFetch()
  }
  
  // MARK: - Private methods
  func performFetch() {
    do {
      try fetchedResultController.performFetch()
    } catch {
      fatalCoreDataError(error)
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditLocation" {
      let controller = segue.destination as! LocationDetailsViewController
      controller.managedObjectContext = managedObjectContext
      
      if let indexpath = tableView.indexPath(for: sender as! UITableViewCell) {
        let location = fetchedResultController.object(at: indexpath)
        controller.locationToEdit = location
      }
    }
  }
}

extension LocationsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultController.sections!.count
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionInfo = fetchedResultController.sections![section]
    return sectionInfo.name
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = fetchedResultController.sections![section]
    return sectionInfo.numberOfObjects
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
    let location = fetchedResultController.object(at: indexPath)
    cell.configure(for: location)
    return cell
  }
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let location = fetchedResultController.object(at: indexPath)
      managedObjectContext.delete(location)
      do {
        try managedObjectContext.save()
      } catch {
        fatalCoreDataError(error)
      }
    }
  }
}
// MARK: - NSFetchedResultsController Delegate
extension LocationsViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerWillChangeContent")
    tableView.beginUpdates()
  }
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      print("*** NSFetchedResultChangesInsert")
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      print("*** NSFetchedResultChangeDelete")
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      print("*** NSFetchedResultChangeUpdate")
      if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
        let location = controller.object(at: indexPath!) as! Location
        cell.configure(for: location)
      }
    case .move:
      print("*** NSFetchedResultChangeMove (object)")
      tableView.deleteRows(at: [indexPath!], with: .fade)
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      print("*** NSFetchedResultChangeInsert (section)")
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      print("*** NSFetchedResultChangeDelete (section)")
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .update:
      print("*** NSFetchedResultChangeUpdate (section)")
    case .move:
      print("*** NSFetchedResultChangeMove (section)")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerDidChangeContent")
    tableView.endUpdates()
  }
}
