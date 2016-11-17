###
# Copyright (C) 2014-2016 Taiga Agile LLC <taiga@taiga.io>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: invite-members.controller.coffee
###

class InviteMembersController
    @.$inject = [
        "tgCurrentUserService"
    ]

    constructor: (@currentUserService) ->
        @.invitedMembers = []
        @.user = @currentUserService.getUser()
        @.validMembers = @.members.filter (member) =>
            member.get('id') != @.user.get('id')
        # @.getDefaultInvitedMembers(@.validMembers)

    getDefaultInvitedMembers: (validMembers) ->
        @.invitedMembers = validMembers.map (member) => member.get('id')
        console.log @.invitedMembers.toJS()

    toggleInviteMember: (member) ->
        if @.invitedMembers.includes(member.get('id'))
            index = @.invitedMembers.indexOf(member.get('id'))
            @.invitedMembers = @.invitedMembers.remove(index)
        else
            @.invitedMembers = @.invitedMembers.push(member.get('id'))

        console.log @.invitedMembers.toJS()
        @.onSetInvitedMembers({members: @.invitedMembers})

angular.module("taigaProjects").controller("InviteMembersCtrl", InviteMembersController)
