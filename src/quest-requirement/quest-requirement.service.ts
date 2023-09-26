import { Injectable } from '@nestjs/common';
import { CreateQuestRequirementDto } from './dto/create-quest-requirement.dto';
import { UpdateQuestRequirementDto } from './dto/update-quest-requirement.dto';

type RequirementStrategy = {
  ref: string;
};

@Injectable()
export class QuestRequirementService {
  public requirementTypes: RequirementStrategy[] = [
    {
      ref: 'eth_holder',
    },
    {
      ref: 'eth_holder_eq',
    },
    {
      ref: 'eth_holder_gte',
    },
    {
      ref: 'supplied_assets',
    },
    {
      ref: 'deposit',
    },
  ];

  create(createQuestRequirementDto: CreateQuestRequirementDto) {
    return 'This action adds a new questRequirement';
  }

  findAll() {
    return `This action returns all questRequirement`;
  }

  findOne(id: number) {
    return `This action returns a #${id} questRequirement`;
  }

  update(id: number, updateQuestRequirementDto: UpdateQuestRequirementDto) {
    return `This action updates a #${id} questRequirement`;
  }

  remove(id: number) {
    return `This action removes a #${id} questRequirement`;
  }
}
