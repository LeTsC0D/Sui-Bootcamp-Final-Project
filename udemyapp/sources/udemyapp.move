
module udemyapp::udemyapp {
  // use sui::Object;
  use std::option::{Self, Option}; 
  use std::debug::print as print;
  use std::string:: {Self, String};
  use sui::transfer;
  use sui::object:: {Self, UID,ID};
  use sui::tx_context::{Self, TxContext};
  use sui::url::{Self, Url};
  use sui::coin:: {Self, Coin};
  use sui::sui::SUI;
  use sui::object_table:: {Self, ObjectTable}; 
  use sui::transfer::{public_transfer, public_share_object};
  use sui::event;
  const NOT_THE_OWNER: u64 = 0; 
  const INSUFFICIENT_FUNDS: u64 = 1; 
  const MIN_CARD_COST: u64 = 1; 

  struct Student has key, store {
    id: UID, 
    studentName: String,
    age:u8,
    phone:u64,
    email:String,
    residentialAddress:String,
    techStack:String,
    yearsOfExperience:u8,
    githubProfile:String,
    linkedinProfile:String,
    openToWork:bool,
    collegeName:String,
    currentCompany:String,
    resumeLink:Url,
    counter: u64,
    
  }

  struct Instructor has key, store {
    id: UID, 
    instructorName: String,
    age:u8,
    phone:u64,
    email:String,
    residentialAddress:String,
    techStack:String,
    yearsOfExperience:u8,
    githubProfile:String,
    linkedinProfile:String,
    currentCompany:String,
    previousCompany:String,
    resumeLink:Url,
    counter: u64,
  }

  struct CourseHub has key, store {
    id: UID, 
    courseName: String,
    courseTitle: String,
    img_url: Url,
    description: String,
    technologies: String,
    instructor:String,
    studentsEnrolled:u64,
    counter: u64,
    studentCards: ObjectTable<u64, Student>,
    instructorCards: ObjectTable<u64, Instructor>,
    owner: address,
  }

  struct CourseCategoryHub has key, store { 
    id: UID, 
    categoryName: String,
    categoryTitle: String,
    img_url: Url,
    description: String,
    technologies: String,
    counter: u64,
    owner: address,
  }

  struct UdemyHub has key,store {
    id: UID,
    owner: address,
    counter: u64,
    courseCategoryHubCards: ObjectTable<u64, CourseCategoryHub>
  }

  //events
  struct CourseCategoryCreated has copy, drop {
    id:ID,
    categoryName: String,
    owner: address,
    categoryTitle: String,
  }

  //events
  struct CourseCategoryUpdated has copy, drop {
    categoryName: String,
    categoryTitle: String,
    img_url: Url,
    description: String,
    technologies: String,    
  }

  //events
  struct CourseCategoryDeleted has copy, drop {
    categoryName: String,
    categoryTitle: String   
  }

  //events
  struct CourseCreated has copy, drop {
    id:ID,
    courseName: String,
    owner: address,
    courseTitle: String,
  }

  //events
  struct InstructorCreated has copy, drop {
    id:ID,
    instructorName: String,
    owner: address,
    email: String,
  }

  //events
  struct StudentCreated has copy, drop {
    id:ID,
    studentName: String,
    owner: address,
    email: String,
  }

  //init function
  fun init(ctx: &mut TxContext) {   
    transfer::share_object( UdemyHub {
      id: object::new(ctx),
      counter: 0,
      courseCategoryHubCards: object_table::new(ctx),
      owner: tx_context::sender(ctx), 
      }
    ); 
    transfer::share_object( CourseHub {
      id: object::new(ctx),
      courseName: string:: utf8(b""),
      courseTitle: string:: utf8(b""),
      img_url: url::new_unsafe_from_bytes(b""),
      description: string:: utf8(b""),
      technologies: string:: utf8(b""),
      instructor: string:: utf8(b""),
      studentsEnrolled: 0,      
      counter: 0,
      studentCards: object_table::new(ctx),
      instructorCards: object_table::new(ctx),
      owner: tx_context::sender(ctx), 
      }
    ); 
  }


public entry fun create_courseCategory(
  categoryName: vector<u8>,
  categoryTitle: vector<u8>,
  img_url: vector<u8>,
  description: vector<u8>,
  technologies: vector<u8>, 
  udemyhub: &mut UdemyHub, 
  coursehub: &mut CourseHub,
  coin:Coin<SUI>,
  ctx: &mut TxContext
 ){
  let value = coin::value (&coin);
  assert! (value == MIN_CARD_COST, INSUFFICIENT_FUNDS); 
  transfer::public_transfer (coin, udemyhub.owner);
  udemyhub.counter = udemyhub.counter + 1;
  coursehub.counter = coursehub.counter + 1;
  let id = object::new(ctx);
  event::emit( 
    CourseCategoryCreated {
      id: object::uid_to_inner(&id),
      categoryName: string::utf8(categoryName),
      owner: tx_context::sender(ctx), 
      categoryTitle: string::utf8(categoryTitle)
    }
  );
  let courseCategory = CourseCategoryHub{
    id: id,
    categoryName: string::utf8(categoryName),
    categoryTitle: string::utf8(categoryTitle),
    owner: tx_context::sender(ctx),
    img_url: url::new_unsafe_from_bytes(img_url),
    description: string::utf8(description),
    technologies: string::utf8(technologies),
    counter: udemyhub.counter,
  };
  object_table::add(&mut udemyhub.courseCategoryHubCards, udemyhub.counter, courseCategory)
 }

 

  public fun update_courseCategory(
    new_categoryName: vector<u8>, 
    new_categoryTitle: vector<u8>, 
    new_img_url: vector<u8>, 
    new_description: vector<u8>, 
    new_technologies: vector<u8>,    
    id: u64,
    coin:Coin<SUI>,
    udemyhub: &mut UdemyHub, 
    ctx: &mut TxContext){ 
    let value = coin::value (&coin);
    assert! (value == MIN_CARD_COST, INSUFFICIENT_FUNDS); 
    transfer::public_transfer (coin, udemyhub.owner);      
    let udemyapp_card=object_table::borrow_mut(&mut udemyhub.courseCategoryHubCards, id);
    udemyapp_card.categoryName = string::utf8(new_categoryName);
    udemyapp_card.categoryTitle = string::utf8(new_categoryTitle);
    udemyapp_card.img_url = url::new_unsafe_from_bytes(new_img_url);
    udemyapp_card.description = string::utf8(new_description);
    udemyapp_card.technologies = string::utf8(new_technologies);

    event::emit( 
      CourseCategoryUpdated {
        categoryName : string::utf8(new_categoryName),
        categoryTitle : string::utf8(new_categoryTitle),
        img_url : url::new_unsafe_from_bytes(new_img_url),
        description : string::utf8(new_description),
        technologies : string::utf8(new_technologies)
      }
    );
  }

  public fun get_CourseCategory(udemyapp: &UdemyHub,id: u64 ): &CourseCategoryHub {  
      let courseCategoryHub_card=object_table::borrow(&udemyapp.courseCategoryHubCards, id);
      return courseCategoryHub_card
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext){
    init(ctx);
  }

  #[test_only]
  public fun get_udemyhub_testing(ctx: &mut TxContext) {

      public_share_object(
        UdemyHub {
          id: object::new(ctx),
          counter: 0,
          courseCategoryHubCards: object_table::new(ctx),
          owner: tx_context::sender(ctx)
        }
      )
  }

  #[test_only]
  public fun get_coursehub_testing(ctx: &mut TxContext) {
      public_share_object( CourseHub {
        id: object::new(ctx), 
        courseName: string::utf8(b""),
        courseTitle: string::utf8(b""),
        img_url: url::new_unsafe_from_bytes(b""),
        description: string::utf8(b""),
        technologies: string::utf8(b""),
        instructor:string::utf8(b""),
        studentsEnrolled:0,
        counter: 0,
        studentCards: object_table::new(ctx),
        instructorCards: object_table::new(ctx),
        owner: tx_context::sender(ctx)
      }
      )
  }

}