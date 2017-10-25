require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#complete_all_tasks!' do
    it 'should mark all tasks from the list as complete' do
      list = List.create(name: "Chores")
      Task.create(
                  list_id: list.id,
                  complete: false,
                  name: "Take out the Trash"
                  )
      Task.create(
                  list_id: list.id,
                  complete: false,
                  name: "Mow the Lawn"
                  )
      list.complete_all_tasks!
      list.tasks.each do |task|
        expect(task.complete).to eq(true)
      end
    end
  end

  describe '#snooze_all_tasks!' do
    it 'should snooze each task in the list' do
      list = List.create(name: "Kitchen Project")
      time_objects = [1.second.from_now, 1.hour.from_now, 6.hours.ago]
      time_objects.each do |time_object|
        Task.create(
           deadline: time_object,
           list_id: list.id
           )
      end
      list.snooze_all_tasks!

      list.tasks.each_with_index do |task, index|
        expect(task.deadline).to eq(time_objects[index] + 1.hour)
      end
    end 
  end

  describe '#total_duration' do
    it 'should return the sum of the duration of all tasks on list' do  
      list = List.create(name: "Meeting")
      Task.create(list_id: list.id, duration: 20)
      Task.create(list_id: list.id, duration: 57)
      Task.create(list_id: list.id, duration: 134)
      expect(list.total_duration).to eq(211)
    end
  end

  describe '#incomplete_tasks' do
    it 'should return an array of all incomplete tasks from list' do
      list = List.create(name: "Cereals")
      task_1 = Task.create(list_id: list.id, complete: false)
      task_2 = Task.create(list_id: list.id, complete: true)
      task_3 = Task.create(list_id: list.id, complete: false)
      task_4 = Task.create(list_id: list.id, complete: false)
      expect(list.incomplete_tasks).to match_array([task_3,task_1,task_4])
      # expect(list.incomplete_tasks).to be_an Array
      expect(list.incomplete_tasks.count).to eq(3)
      list.incomplete_tasks.each do |task|
        expect(task.complete).to eq(false)
      end
    end
  end

  describe '#favorite_tasks' do
    it 'should return an array of all favorite tasks from list' do
      list = List.create(name: "Play list")
      task_1 = Task.create(list_id: list.id, favorite: true)
      task_2 = Task.create(list_id: list.id, favorite: false)
      task_3 = Task.create(list_id: list.id, favorite: true)
      task_4 = Task.create(list_id: list.id, favorite: false)
      expect(list.favorite_tasks).to match_array([task_3,task_1])
    end
  end
end










